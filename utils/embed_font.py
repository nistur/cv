#!/usr/bin/python3
import sys
from PIL import Image

im = Image.open(sys.argv[1])
px = im.load()

c = 40

black = (0,0,0)

glyphs = []

for c in range(0,256):

    x = c % 16
    y = c // 16

    x = x * 8
    y = y * 16

    glyph = []
    for oy in range(0, 16):
        byte = 0
        for ox in range(0, 8):
            byte = byte << 1
            p = px[x+ox, y+oy]
            if (p==black): byte = byte | 1
        glyph.append(byte)
    glyphs.append(glyph)


for c in range(0, 256):
    glyph = glyphs[c]
    print("char CHAR_{0:03d}[] =".format(c))
    print("{")
    print('    ', ','.join(hex(x) for x in glyph[:8]), end=',\n', sep='')
    print('    ', ','.join(hex(x) for x in glyph[8:]), end='\n', sep='')
    print("};")

print("")
print("")

print("#define C(x) CHAR_##x")

print("")
print("")

print("char* font[] =")
print("{")

for y in range(0,16):
    print("    ", end='')
    for x in range(0,16):
        print("C({0:03d}),".format(x+(y*16)), end='')
    print("")

print("};")
