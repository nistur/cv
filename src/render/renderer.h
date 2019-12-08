#import <Foundation/NSObject.h>
#import "glyphtable.h"
#import "char.h"

@interface Renderer:NSObject
{
    GlyphTable* m_table;
}
+(Renderer*) rendererWithGlyphTable:(GlyphTable*)table;

-(void) renderCharacter:(Char*)c;
@end
