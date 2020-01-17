#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import "glyph.h"

@interface GlyphTable:NSObject
{
    Glyph* m_table[0xFF];
}

-(void) addGlyphForCharacter:(unsigned char)c withData:(char*)d;
-(void) addGlyphForUnknownWithData:(char*)d;
-(Glyph*) glyphFromCharacter:(unsigned char)c;
@end
