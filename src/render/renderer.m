#import "renderer.h"

@implementation Renderer
+(Renderer*) rendererWithGlyphTable:(GlyphTable*)table andFramebuffer:(Framebuffer*)fb
{
    Renderer* renderer = [Renderer new];
    renderer->m_table = table;
    renderer->m_framebuffer = fb;
    renderer->x = 0;
    renderer->y = 0;
    return renderer;
}

-(void) renderCharacter:(Char*)c
{
    Glyph* glyph = [m_table glyphFromCharacter:[c getChar]];
    if(glyph)
    {
//	[c print];
	[glyph renderAtX:x andY:y toFramebuffer:m_framebuffer];
    };
    x += 8;
    if(x > 640)
    {
	x = 0;
	y += 16;
    }
}
@end
