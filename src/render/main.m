#import <Foundation/Foundation.h>
#import "row.h"
#import "renderer.h"
#import "framebuffer.h"

char CHAR_H[] = {
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11111110,
    0b11111110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b00000000
};

char CHAR_e[] = {
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00011100,
    0b01100110,
    0b01111110,
    0b01100000,
    0b01100000,
    0b01100110,
    0b00111100,
    0b00000000
};

char CHAR_o[] = {
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00000000,
    0b00011100,
    0b01100110,
    0b01100110,
    0b01100110,
    0b01100110,
    0b01100110,
    0b00111100,
    0b00000000
};

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
		row = [row new];
		[array addObject:row];
	    }
	}
    }

    
    GlyphTable* table = [GlyphTable new];
    [table addGlyphForCharacter:'H' withData:CHAR_H];
    [table addGlyphForCharacter:'e' withData:CHAR_e];
    [table addGlyphForCharacter:'o' withData:CHAR_o];
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
