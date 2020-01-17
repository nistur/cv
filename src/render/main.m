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

char CHAR_UNKNOWN[] = {
    0b00000000,
    0b00111100,
    0b01100110,
    0b01000010,
    0b01011010,
    0b01001010,
    0b01001010,
    0b01011010,
    0b01010010,
    0b01000010,
    0b01010010,
    0b01100110,
    0b00111100,
    0b00000000,
    0b00000000,
    0b00000000,
};

int main(int argc, char** argv)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    Row* row = [Row new];

    [row addCharacter:'H'];
    [row addCharacter:'e'];
    [row addCharacter:'l'];
    [row addCharacter:'l'];
    [row addCharacter:'o'];
    [row addCharacter:','];
    [row addCharacter:' '];
    [row addCharacter:'W'];
    [row addCharacter:'o'];
    [row addCharacter:'r'];
    [row addCharacter:'l'];
    [row addCharacter:'d'];
    
    GlyphTable* table = [GlyphTable new];
    [table addGlyphForCharacter:'H' withData:CHAR_H];
    [table addGlyphForCharacter:'e' withData:CHAR_e];
    [table addGlyphForCharacter:'o' withData:CHAR_o];
    [table addGlyphForUnknownWithData:CHAR_UNKNOWN];
    
    Framebuffer* fb = [Framebuffer framebufferWithWidth:640 andHeight:400 andDepth:1];
    Renderer* renderer = [Renderer rendererWithGlyphTable:table andFramebuffer:fb];
    [row renderWithRenderer:renderer];
    [fb print];

    [table release];
    
    [row release];

    [pool drain];
    
    return 0;
}
