#import <Foundation/NSObject.h>

@interface Char:NSObject
{
    char m_c;
}
+(Char*) newWithChar:(char)c;

-(void) print;

-(void) setChar:(char) c;

-(char) getChar;
@end
