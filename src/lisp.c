#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "stretchy_buffer.h"

typedef char* sym_t;

typedef struct
{
    int _refCount;
} ref_t;

#define REFCOUNT ref_t _ref;

typedef enum
{
    SYM,
    LIST,
    VAL,
    BOOL,
    NUM,
    FUNL,// Lisp fn
    FUNC,// C fn
    QUOT,// '
} cell_type;

typedef struct _cell_base_t
{
    REFCOUNT;
    struct _cell_base_t* next;
    cell_type t;
} cell_base_t;
typedef struct _list_t
{
    cell_base_t _base;
    cell_base_t* car;
    cell_base_t* cdr;
} list_t;

typedef struct _fn_t
{
    cell_base_t _base;
    list_t*      params;
    list_t*      body;
} fn_t;
    
struct _env_t;
typedef cell_base_t* (*func)(cell_base_t*, cell_base_t*, struct _env_t* env);

typedef struct _cell_t
{
    cell_base_t _base;
    union { sym_t sym; int val; func func; };
} cell_t;

typedef list_t*     ast_t;
typedef struct _env_t
{
    int*           keys;
    cell_base_t**  vals;
    struct _env_t* _parent;
} *env_t;

void Free(cell_base_t* cell);
#define FREE(v) Free((cell_base_t*)v)

#define RETAIN(_val) { ((ref_t*)_val)->_refCount += 1; }
#define RELEASE(_val) { if((((ref_t*)_val)->_refCount-= 1) <= 0) { FREE(_val); }}

cell_base_t* Get(env_t env, int hash);
cell_base_t* Replace(env_t env, int hash, cell_base_t* val);
#define _SET(XX,val) {sb_push(env->keys, XX); sb_push(env->vals, val); RETAIN(val);}
#define SET(name,val) _SET(hash(name), val) 
#define GET(name) Get(env, hash(name))
#define REPLACE(name, val) Replace(env, hash(name), val);

cell_base_t* _cell(cell_type t, void* val)
{
    cell_base_t* cell;
    if(t == LIST)
    {
	cell = malloc(sizeof(list_t));
    }
    else if(t == FUNL)
    {
	cell = malloc(sizeof(fn_t));
    }
    else
    {
	cell = malloc(sizeof(cell_t));
	((cell_t*)cell)->sym = (sym_t)val;
    }
    cell->t = t;
    RETAIN(cell);
    return cell;
}
#define CELL(t, v) _cell(t, (void*)v)
#define LIST() (list_t*)CELL(LIST,0)
#define FUNL() (fn_t*)CELL(FUNL,0)
#define QUOTE() (list_t*)CELL(QUOT,0)

int hash(const char* str)
{
    int h = 5381;
    while(*str)
    {
	h = ((h <<5) + h) + *str;
	++str;
    }
    return h;
}

cell_base_t* NIL;

#define PUSH_BACK(list, val)						\
    {									\
	if( list->car == NULL ) { list->car = val; }			\
	else if( list->cdr == NULL )					\
	{								\
	    list->cdr = val; list->car->next = val;			\
	}								\
	else								\
	{								\
	    cell_base_t* pCell = list->cdr;				\
	    while( pCell->next != NULL ) pCell = pCell->next;		\
	    pCell->next = val;						\
	}								\
    }

cell_base_t* Pop(list_t* list)
{
    cell_base_t* c = list->car;
    list->car = c ? c->next : NULL;
    list->cdr = list->car ? list->car->next : NULL;
    return c;
}
#define POP Pop

const char* ParseList(list_t* list, const char* expr)
{
    const char* pTokStart = expr;
    const char* pTokEnd = expr + 1;
    while(1)
    {
	if(*pTokStart == '\0')
	{
	    break;
	}
	
	switch(*pTokStart)
	{
	case '\'':
	{
	    cell_base_t* cell = CELL(QUOT, 0);
	    PUSH_BACK(list,cell);
	    pTokEnd = ParseList((list_t*)cell, pTokEnd);
	}
	break;
	case '(':
	{
	    cell_base_t* cell = CELL(LIST, 0);
	    PUSH_BACK(list,cell);
	    pTokEnd = ParseList((list_t*)cell, pTokEnd);
	}
	break;
	case ')':
	    return pTokEnd;
	case ' ':
	    if(list->_base.t == QUOT)
	    {
		return pTokEnd; // if we're quoting, just break on the next space
	    }
	    break;
	default:
	{
	    while(*pTokEnd != '\0' && *pTokEnd !=  ' ' &&
		  *pTokEnd != '\n' && *pTokEnd != '\t' &&
		  *pTokEnd != '('  && *pTokEnd !=  ')' )
		++pTokEnd;

	    int len = pTokEnd - pTokStart;
	    char* sym = malloc(len + 1);
	    memcpy(sym, pTokStart, len);
	    sym[len] = 0;
	    PUSH_BACK(list, CELL(SYM, sym));
	}
	break;
	}
	
	pTokStart = pTokEnd;
	pTokEnd = pTokStart+1;
    }
    return pTokStart;
}

ast_t Parse(const char* expr)
{
    ast_t ast = LIST();
    ParseList(ast, expr);
    return ast;
}

cell_base_t* Eval(cell_base_t* car, cell_base_t* cdr, env_t env)
{
    if(car->t == QUOT)
    {
	return ((list_t*)car)->car;
    }
    
    while(car->t == LIST)
    {
	cell_base_t* res = Eval(((list_t*)car)->car, ((list_t*)car)->cdr, env);
	//RELEASE(car);
	car = res;
    }
    
    if(car->t == SYM)
    {
	cell_base_t* val = GET(((cell_t*)car)->sym);
	if( val != NULL )
	{
	    if( val->t == FUNC )
	    {
		return ((cell_t*)val)->func(cdr, cdr->next, env);
	    }
	    else if( val->t == FUNL )
	    {
		env_t scope = malloc(8);
		scope->_parent = env;
		cell_base_t* name = ((fn_t*)val)->params->car;
		cell_base_t* var = cdr ? ((list_t*)cdr)->car : NIL;
		while(name && val)
		{
		    name = name->next;
		    var = var->next;
		}
		val = Eval(((cell_base_t*)((fn_t*)val)->body), ((fn_t*)val)->body->car->next, scope);
		
		free(scope);
	    }
	    return val;
	}
    }
    return car;
}

void Free(cell_base_t* cell)
{
    switch(cell->t)
    {
    case SYM:
	free(((cell_t*)cell)->sym);
	break;
    case LIST:
    case QUOT:
    {
	cell_base_t* car = ((list_t*)cell)->car;
	while(car)
	{
	    cell_base_t* next = car->next;
	    RELEASE( car );
	    car = next;
	}
    }
    break;
    }
    free(cell);
}

cell_base_t* Get(env_t env, int hash)
{
    for(int i = 0; i < sb_count(env->keys); ++i)
    {
	if(env->keys[i] == hash)
	{
	    return env->vals[i];
	}
    }
    if( env->_parent )
    {
	return Get(env->_parent, hash);
    }
    return NULL;
}

cell_base_t* Replace(env_t env, int hash, cell_base_t* val)
{
    env_t scope = env;
    while(scope)
    {
	for(int i = 0; i < sb_count(scope->keys); ++i)
	{
	    if(scope->keys[i] == hash)
	    {
		RELEASE(scope->vals[i]);
		scope->vals[i] = val;
		return val;
	    }
	}
	scope = scope->_parent;
    }
    _SET(hash, val);
    return val;
}

cell_base_t* println(cell_base_t* car, cell_base_t* cdr, env_t env)
{
    while( car )
    {
	cell_base_t* res = Eval(car, cdr, env);
	if(res->t == SYM) printf("%s\n", ((cell_t*)res)->sym);
	if(res->t == VAL) printf("%d\n", ((cell_t*)res)->val);
	car = car->next;
    }
    return NIL;
}

cell_base_t* plus(cell_base_t* car, cell_base_t* cdr, env_t env)
{
    int val = 0;
    cell_base_t* cell = car;
    while( cell )
    {
	cell_base_t* res = Eval(cell, cell->next, env);
	if(res->t == SYM)
	{
	    val += atoi(((cell_t*)res)->sym);
	}
	else if( res->t == VAL)
	{
	    val += ((cell_t*)res)->val;
	}
	cell = cell->next;
    }
    return CELL( VAL, val );
}    

cell_base_t* set(cell_base_t* car, cell_base_t* cdr, env_t env)
{
    cell_base_t* name = Eval(car, cdr, env);
    if( name != NULL && name->t == SYM)
    {
	cell_base_t* val = Eval(cdr, cdr->next, env);
	REPLACE(((cell_t*)name)->sym, val);
	return val;
    }
    return NIL;
}

cell_base_t* lambda(cell_base_t* car, cell_base_t* cdr, env_t env)
{
    {
	fn_t* val = FUNL();
	if(car->t == LIST)
	{
	    val->params = (list_t*)car;
	    val->body = (list_t*)cdr;
	    return &val->_base;
	}
    }
    return NIL;
}

void lisp(void)
{
    env_t env = malloc(8);
    SET("println", CELL(FUNC, println));
    SET("+", CELL( FUNC, plus));
    SET("set", CELL( FUNC, set));
    SET("lambda", CELL( FUNC, lambda));
    
    NIL = CELL(VAL, 0 );
    ast_t ast = Parse(
	"(set 'one 1) \
         (set 'test lambda () \
             (println (set 'one (+ one 1)))) \
         (test) \
         (test) \
         (test)");
//    ast_t ast = Parse("(set 'one 1)(println (+ one 2))");
    cell_base_t* cell = ast->car;
    while( cell )
    {
	Eval( cell, cell->next, env );
	cell = cell->next;
    }
    
    RELEASE( ast );

    for(int i = 0; i < sb_count( env->vals ); ++i)
    {
	RELEASE(env->vals[i]);
    }
    sb_free(env->keys); sb_free(env->vals);
}
