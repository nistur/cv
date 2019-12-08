#PDF output directory
OUT_DIR=out/pdf/
#Directory to copy intermediate LaTeX files to
OBJ_DIR=out/tex/
#auxiliary files which pdflatex outputs --- Don't actually know what these are, but I don't need them
AUX_DIR=out/aux/
#directory for executables
BIN_DIR=out/bin/
#directory for man pages
MAN_DIR=out/man/
#images go here
IMG_DIR=out/png/
#tools we will user
TOOLS_DIR=tools/
SRC_DIR=src/
#use line below if want to compile all org files, CV just uses one which includes others
#FILES=$(patsubst %.org,$(OUT_DIR)/%.pdf,$(wildcard *.org))
CFLAGS=-g
SILENT=2>/dev/null > /dev/null

PROJS=exe render tools man pdf

.PHONY: all clean $(PROJS)

all: $(PROJS)

exe:
	@echo "Making executable"
	@make -f Makefile.$@  $(SILENT)

render:
	@echo "Objectifying renderer"
	@make -f Makefile.$@ $(SILENT)

tools:
	@echo "Finding some tools"
	@make -f Makefile.$@ $(SILENT)

man:
	@echo "Manning the data"
	@make -f Makefile.$@ $(SILENT)

pdf:
	@echo "Compiling scrolls to make the perfect document"
	@make -f Makefile.$@ $(SILENT)

clean:
	@echo "Cleaning output directories"
	@rm -fr $(OUT_DIR)
	@rm -fr $(AUX_DIR)
	@rm -fr $(OBJ_DIR)
	@rm -fr $(BIN_DIR)
	@rm -fr $(MAN_DIR)
	@rm -fr $(TOOLS_DIR)/bin
