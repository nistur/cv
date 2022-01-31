#output directory
OUT_DIR=out
TOOLS_DIR=tools/
SRC_DIR=src/

SILENT=2>/dev/null > /dev/null

#PROJS=exe render tools man pdf 1page
PROJS=exe tools man pdf

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


1page:
	@echo "Finding a page"
	@make -f Makefile.$@ $(SILENT)

clean:
	@echo "Cleaning output directories"
	@make -f Makefile.exe clean $(SILENT)
	@make -f Makefile.render clean $(SILENT)
	@make -f Makefile.tools clean $(SILENT)
	@make -f Makefile.man clean $(SILENT)
	@make -f Makefile.pdf clean $(SILENT)
	@rm -fr $(OUT_DIR)
