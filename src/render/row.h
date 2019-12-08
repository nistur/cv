#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import "char.h"
#import "renderer.h"

@interface Row:NSObject
{
    NSMutableArray* m_row;
}
-(void) renderWithRenderer:(Renderer*)renderer;
-(void) addCharacter:(char)c;
@end
