#import "char.h"
#import <stdio.h>

@implementation Char

+(Char*) newWithChar:(char)c
{
    Char* val = [Char new];
    [val setChar:c];
    return val;
}

-(void) print
{
    printf("%c", m_c);
}

-(void) setChar:(char)c
{
    m_c = c;
}

-(char) getChar
{
    return m_c;
}

@end
