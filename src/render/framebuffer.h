#import <Foundation/NSObject.h>

@interface Framebuffer: NSObject
{
    void* m_buffer;
    int m_width, m_height, m_depth;
}
+(Framebuffer*) framebufferWithWidth:(int)width andHeight:(int)height andDepth:(int)depth;

-(void) print;
-(void) setPixelColour:(void*) col atX:(int)x andY:(int)y;
@end
