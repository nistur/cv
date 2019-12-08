#import <Foundation/NSObject.h>

@interface Glyph:NSObject
{
    char m_data[16];
}
+(id) newGlyphWithData:(char*)d;
@end
