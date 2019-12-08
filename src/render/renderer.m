#import "renderer.h"

@implementation Renderer
+(Renderer*) rendererWithGlyphTable:(GlyphTable*)table
{
    Renderer* renderer = [Renderer new];
    renderer->m_table = table;
    return renderer;
}

-(void) renderCharacter:(Char*)c
{
    Glyph* glyph = [m_table glyphFromCharacter:[c getChar]];
    if(glyph)
    {
	[c print];
    };
}
@end
