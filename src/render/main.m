#import <Foundation/Foundation.h>
#import "row.h"
#import "renderer.h"
#import "framebuffer.h"

#import "font.h"

int main(int argc, char** argv)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    Row* row = [Row new];

    [row addCharacter:'H'];
    [row addCharacter:'E'];
    [row addCharacter:'L'];
    [row addCharacter:'L'];
    [row addCharacter:'O'];
    [row addCharacter:','];
    [row addCharacter:' '];
    [row addCharacter:'W'];
    [row addCharacter:'O'];
    [row addCharacter:'R'];
    [row addCharacter:'L'];
    [row addCharacter:'D'];
    
    GlyphTable* table = [GlyphTable new];
    unsigned char c = 0;
    for(c = 0; c < 0xFF; ++c)
    {
	[table addGlyphForCharacter:c withData:font[c]];
    }
    
    Framebuffer* fb = [Framebuffer framebufferWithWidth:640 andHeight:400 andDepth:1];
    Renderer* renderer = [Renderer rendererWithGlyphTable:table andFramebuffer:fb];
    [row renderWithRenderer:renderer];
    [fb print];

    [table release];
    
    [row release];

    [pool drain];
    
    return 0;
}
