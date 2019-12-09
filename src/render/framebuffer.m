#import "framebuffer.h"
#import <stdio.h>

@implementation Framebuffer
+(Framebuffer*) framebufferWithWidth:(int)width andHeight:(int)height andDepth:(int)depth
{
    Framebuffer* fb = [Framebuffer new];
    fb->m_width = width;
    fb->m_height = height;
    fb->m_depth = depth;
    depth = depth / 8;
    depth = depth > 0 ? depth : 1;
    fb->m_buffer = malloc(width * height * depth);

    return fb;
}

-(void) print
{
    int x, y;
    printf("P3\n");
    printf("%d %d\n", m_width, m_height);
    printf("255\n");
    for(y = 0; y < m_height; ++y)
    {
	for(x = 0; x < m_width; ++x)
	{
	    char val = ((char*)m_buffer)[(y * m_width ) + x];
	    printf("%d %d %d ", val ? 64 : 0, val ? 255 : 0, val ? 72 : 0);
	}
	printf("\n");
    }
}

-(void) setPixelColour:(void*) col atX:(int)x andY:(int)y
{
    memcpy(&((char*)m_buffer)[(y * m_width ) + x], col, 1);
}
@end
