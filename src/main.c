#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Generated by embed.sh
#include "cv.org.h"

// Generated by embed_lisp.sh
#include "main.l.h"

// Custom lisp interpreter
void lisp(const char* expr);

// Print basic help in a Unix CLI style help
void printHelp(const char* name)
{
    printf("Usage: %s [OPTION]...\n"					\
	   "Curriculum Vitae for Philipp Geyer\n"			\
	   "\n"								\
	   "Output options\n"						\
	   " -p\tPersonal Information\n"				\
	   " -e\tExperience\n"						\
	   " -s\tSkills\n"						\
	   " -q\tQualifications\n"					\
	   " -l\tLanguages\n"						\
	   " -i\tInterests\n"						\
	   " -c\tContact\n"						\
	   "\n", name);
}

// Contact information - not found in exported CV at this stage
void printContact(void)
{
    printf(" ");
}

int main(int argc, char** argv)
{
    int opt;
    char optHandled = 0;

    // quick macro just to wrap up pulling the paragraphs from the
    // exported CV data
#define CV_PARAGRAPH(NUM)				\
    optHandled = 1; printf("\n%s\n", cv_org##NUM);
    
    while( (opt = getopt(argc, argv, "pesqlichL")) != -1 )
    {
	switch( opt )
	{	
	case 'p':
	    CV_PARAGRAPH(00); break;
	case 'e':
	    CV_PARAGRAPH(01); break;
	case 's':
	    CV_PARAGRAPH(02); break;
	case 'q':
	    CV_PARAGRAPH(03); break;
	case 'l':
	    CV_PARAGRAPH(04); break;
	case 'i':
	    CV_PARAGRAPH(05); break;
	case 'c':
	    optHandled = 1; printContact(); break;

	    // fire up a lisp interpreter. Because why not
	case 'L':
	    optHandled = 1; lisp(main_l); break;
	    
	case 'h':
	default:
	    // this is handled below with !optHandled
	    break;
	}
    }

    if( !optHandled )
    {
	printHelp(argv[0]);
    }
    
    
    return 0;
}
