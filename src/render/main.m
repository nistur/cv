#import <Foundation/Foundation.h>
#import "row.h"
#import "renderer.h"
#import "framebuffer.h"

#import "font.h"

int main(int argc, char** argv)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:25];
    {
	NSInteger i;
	NSFileHandle* input = [NSFileHandle fileHandleWithStandardInput];
	NSData* inputData = [input availableData];
	NSString* string = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];

	Row* row = [Row new];
	[array addObject:row];
	
	for(i = 0; i < string.length; ++i)
	{
	    if([row addCharacter:[string characterAtIndex:i]])
	    {
		row = [Row new];
		[array addObject:row];
	    }
	}
    }
    
    GlyphTable* table = [GlyphTable new];
    unsigned char c = 0;
    for(c = 0; c < 0xFF; ++c)
    {
	[table addGlyphForCharacter:c withData:font[c]];
    }
    
    Framebuffer* fb = [Framebuffer framebufferWithWidth:640 andHeight:400 andDepth:1];
    Renderer* renderer = [Renderer rendererWithGlyphTable:table andFramebuffer:fb];
    
    for(Row* row in array)
    {
	[row renderWithRenderer:renderer];
    }
    
    [fb print];

    [table release];

    for(Row* row in array)
    {
	[row release];
    }
    [array release];

    [pool drain];
    
    return 0;
}
