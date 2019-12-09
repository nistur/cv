#import <Foundation/NSObject.h>

#import "framebuffer.h"

@interface Glyph:NSObject
{
    char m_data[16];
}
+(id) newGlyphWithData:(char*)d;

-(void) renderAtX:(int)x andY:(int)y toFramebuffer:(Framebuffer*)fb;
@end
