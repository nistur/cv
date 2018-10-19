Curriculum Vitae
----------------

This is my CV. It is provided in emacs org-mode. It is then exported with a LaTeX stylesheet through to PDF.

This is not meant to necessarily be so that anyone can grab and build PDFs of my CV, although they can, it's just a way for me to play around with various languages and tech in a vaguely relevant manner. PDF versions of my CV are available in the Releases section.

Tested software used to build the CV PDFs:
- emacs 24.5.1
- org-mode
- pdfTex 3.14159265
- texlive-full (I don't know right now which bits of texlive I'm actually using)
- GNU Make 4.1

In order to build the CV PDF:
```make```

Also added to the repository now is a small C program that will provide the contents of the CV on the command line. This is currently just as a place where I can dump a few more code samples, rather than a complete project. It will also be built with ```make``` above, and can be invoked with ```out/bin/cv``` which will show the available flags. It also contains a very basic lisp interpreter, which currently does very little.