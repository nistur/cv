Curriculum Vitae
----------------

This is my CV. It is provided in emacs org-mode. It is then exported with a LaTeX stylesheet through to PDF. It has also grown to something a bit more than that.

This is not meant to necessarily be so that anyone can grab and build PDFs of my CV, although they can, it's just a way for me to play around with various languages and tech in a vaguely relevant manner. PDF versions of my CV are available in the Releases section.

Tested software used to build the CV in its various forms:
- emacs 24.5.1
- org-mode
- pdfTex 3.14159265
- texlive-full (I don't know right now which bits of texlive I'm actually using)
- GNU Make 4.1
- gcc 8.3.0
- gcc-objc 8.3.0
- GNUstep 1.2.6
- Bash 5.0.3

In order to build the whole CV project:
```make```

There are subprojects for the various output types. These can be invoked on their own by calling `make ${SUBPROJ}` where `${SUBPROJ}` is one of the following
- `exe`
- `man`
- `pdf`
- `render`
- `tools`

Currently the three that produce my CV in some output form or another are `pdf` for the PDF version, `exe` for a small executable version, written in C, and `man` for a troff formatted unit man-page. Future work will add more.

Output files
-------------
- out/pdf/philippgeyer.pdf - The PDF that you probably want.
- out/bin/philippgeyer - Executable version of the CV.
- out/man/philippgeyer.6 - man-page version of the CV.

FAQs
-----
Q. This is pointless.

A. That's not a question, but yes, apart from the fact it's useful having my CV somewhere public, the rest of it is pretty pointless.

Q. Why?

A. Because I like making weird little things. It's not directly relevant to my job really, but I guess it shows that I can work with different technologies, languages, and problems. Just in case someone is wanting to hire me and thinks this means I get distracted at work, I don't believe it does (but of course I _would_ say that, wouldn't I?) I think it just means that I have a broader view of the potential solutions to any given problem.

Q. Why did you use [language X] for [feature n] when you already used [language Y] for [feature m] and it's perfectly suited for the same task?

A. This project started with me needing to rewrite my CV, because I didn't have the source OpenOffice.org files for my previous ones, and I didn't feel like re-installing OO.o anyway. I wanted something quick. So I used emacs [org-mode](https://orgmode.org). I knew I could export to PDF via LaTeX, so I wrote the layout in LaTeX. At that point I figured it'd be fun to have it in an executable format, so I needed a compiled language, I picked C. I needed a build script, GNU Make to the rescue. I needed some way to embed the data into the C executable, nothing used to that point really fit the bill, so I chose to just create a bash script to do it with system tools (ok, I COULD have done that within the makefile, but it would have been very messy) so by this point, I was already using a number of different languages, and I figured it would be fun that every new feature in this project, I'd try to do in a different language.

Q. You could have written it all in Python.

A. Again, not a question, and yes, I probably could have done, and Python is definitely a sensible choice for a lot of things, but I tend to make the argument that Python is not the _best_ solution for an awful lot of problems, that a lot of things could be solved cleaner, easier, or quicker, using other languages and tech. I'm against the everything-is-a-python-shaped-nail way of thinking. And I guess this is a bit of a statement to that effect. I'm perfectly alright using Python for things when they make sense, however.