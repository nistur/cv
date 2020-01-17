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

-(void) addGlyphForUnknownWithData:(char*)d
{
    Glyph* unknownGlyph = [Glyph newGlyphWithData:d];
    unsigned char i = 0;
    for(i ; i < 0xFF; ++i)
    {
	if( m_table[i] == nil )
	{
	    m_table[i] = unknownGlyph;
	}
    }
}

-(Glyph*) glyphFromCharacter:(unsigned char)c
{
    return m_table[c];
}
@end
