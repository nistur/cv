#!/usr/bin/python3
import sys

f = open(sys.argv[1] + ".h", "w")
f.write("const char* ")
f.write(sys.argv[1].replace("src/", "").replace(".", "_"))
f.write(" = \\\n")

l = open(sys.argv[1], "r")
for line in l:
    f.write("\"")
    f.write(line.replace("\n", ""))
    f.write("\" \\\n")

f.write(";\n")

l.close()
f.close()
