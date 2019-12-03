#PDF output directory
OUT_DIR=out/pdf/
#Directory to copy intermediate LaTeX files to
OBJ_DIR=out/tex/
#auxiliary files which pdflatex outputs --- Don't actually know what these are, but I don't need them
AUX_DIR=out/aux/
#directory for executables
BIN_DIR=out/bin/
#directlry for man pages
MAN_DIR=out/man/
#tools we will user
TOOLS_DIR=tools/
#use line below if want to compile all org files, CV just uses one which includes others
#FILES=$(patsubst %.org,$(OUT_DIR)/%.pdf,$(wildcard *.org))
FILES=$(OUT_DIR)/cv.pdf ${BIN_DIR}/cv ${MAN_DIR}/cv.6
CFLAGS=-g
SILENT=2>/dev/null > /dev/null

.PHONY: all clean install-doc tools

all: install-doc tools

install-doc: $(OUT_DIR) $(OBJ_DIR) $(AUX_DIR) $(BIN_DIR) $(MAN_DIR) $(FILES)

tools: $(TOOLS_DIR)bin $(TOOLS_DIR)bin/tlvm $(TOOLS_DIR)bin/asm8080

$(TOOLS_DIR)bin/asm8080:
	@echo "Preparing assembler"
	@make -C tools -f Makefile.asm8080 $(SILENT)

$(TOOLS_DIR)bin/tlvm:
	@echo "Building 8 bit system"
	@make -C tools -f Makefile.tlvm $(SILENT)

$(TOOLS_DIR)bin:
	@mkdir -v -p $(TOOLS_DIR)bin

$(OBJ_DIR):
	@mkdir -v -p $(OBJ_DIR)

$(OUT_DIR):
	@mkdir -v -p $(OUT_DIR)

$(AUX_DIR):
	@mkdir -v -p $(AUX_DIR)

$(BIN_DIR):
	@mkdir -v -p $(BIN_DIR)

$(MAN_DIR):
	@mkdir -v -p $(MAN_DIR)

%.tex: %.org
	@echo "Converting org-mode file $< to LaTeX"
	@emacs $< --batch -f org-latex-export-to-latex --kill $(SILENT)

%.pdf: %.tex
	@echo "Converting LaTeX file $< to PDF"
	@pdflatex $< $(SILENT)
	@echo "Tidying output..."
	@install -m 644 -t $(OBJ_DIR) $<
	@install -m 644 -t $(AUX_DIR) $(<:.tex=.aux)
	@install -m 644 -t $(AUX_DIR) $(<:.tex=.log)
	@install -m 644 -t $(AUX_DIR) $(<:.tex=.out)
	@rm -fr $<
	@rm -fr $(<:.tex=.aux)
	@rm -fr $(<:.tex=.log)
	@rm -fr $(<:.tex=.out)

%.6: %.org
	@echo "Converting org-mode file $< to man-pages"
	@lua utils/org-to-man.lua $<

$(OUT_DIR)/%.pdf: %.pdf
	@install -m 644 -t $(OUT_DIR) $<
	@rm $<

src/cv.dat.h:
	@sh ./utils/embed.sh cv.org

cv.out: src/cv.dat.h src/main.l.h
	@echo "Building executable"
	@gcc -o $@ src/*.c $(CFLAGS)

src/main.l.h:
	@echo "Processing lisp"
	@python3 ./utils/embed_lisp.py src/main.l

$(BIN_DIR)/cv: cv.out
	@mv $< $(BIN_DIR)/cv

$(MAN_DIR)/cv.6: cv.6
	@mv $< $(MAN_DIR)/cv.6

clean:
	@echo "Cleaning output directories"
	@rm -fr $(OUT_DIR)
	@rm -fr $(AUX_DIR)
	@rm -fr $(OBJ_DIR)
	@rm -fr $(BIN_DIR)
	@rm -fr $(MAN_DIR)
	@rm -fr $(TOOLS_DIRR)bin
