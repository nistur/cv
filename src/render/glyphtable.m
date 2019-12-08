#import "glyphtable.h"

@implementation GlyphTable
-(id) init
{
    self = [super init];
    memset(m_table, 0, sizeof(Glyph*) * 0xFF);
    return self;
}

-(void) addGlyphForCharacter:(unsigned char)c withData:(char*)d
{
    m_table[c] = [Glyph newGlyphWithData:d];
}

-(Glyph*) glyphFromCharacter:(unsigned char)c
{
    return m_table[c];
}
@end
