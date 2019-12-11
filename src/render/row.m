#import <stdio.h>
#import "row.h"
#import "char.h"

@implementation Row
-(id) init
{
    self = [super init];
    m_row = [NSMutableArray arrayWithCapacity:80];
    return self;
}

-(void) renderWithRenderer:(Renderer*)renderer
{
    for(Char* c in m_row)
    {
	[renderer renderCharacter:c];
    }
}

-(BOOL) addCharacter:(char)c
{
    [m_row addObject:[Char newWithChar:c]];
    return [m_row count] == 80;
}

@end
