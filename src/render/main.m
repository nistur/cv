#import <Foundation/Foundation.h>
#import "row.h"
#import "renderer.h"

char CHAR_H[] = {
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11111110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b00000000
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
    Renderer* renderer = [Renderer rendererWithGlyphTable:table];
    
    [row renderWithRenderer:renderer];

    [table release];
    
    [row release];

    [pool drain];
    
    return 0;
}
