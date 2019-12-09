#import "glyph.h"
#import <string.h>

@implementation Glyph
-(void) setData:(char*)d
{
    memcpy(m_data, d, 16);
}

+(id) newGlyphWithData:(char*)d
{
    id glyph = [Glyph new];
    [glyph setData:d];
    return glyph;
}

-(void) renderAtX:(int)x andY:(int)y toFramebuffer:(Framebuffer*)fb
{
    int ix, iy;
    for(iy = 0; iy < 16; ++iy)
    {
	for(ix = 0; ix < 8; ++ix)
	{
	    int offs = 8-ix;
	    
	    char data = m_data[iy] & (1<<offs) ? 1 : 0;
	    [fb setPixelColour:&data atX:x+ix andY:y+iy];
	}
    }
}
@end
