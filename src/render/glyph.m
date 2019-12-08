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
@end
