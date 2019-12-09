#import <Foundation/NSObject.h>
#import "glyphtable.h"
#import "char.h"
#import "framebuffer.h"

@interface Renderer:NSObject
{
    GlyphTable* m_table;
    Framebuffer* m_framebuffer;
    int x,y;
}
+(Renderer*) rendererWithGlyphTable:(GlyphTable*)table andFramebuffer:(Framebuffer*)fb;

-(void) renderCharacter:(Char*)c;
@end
