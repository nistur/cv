#include <stdio.h>
#include <unistd.h>
#include "cv.org.h"

void printHelp(const char* name)
{
    printf("Usage: %s [OPTION]...\n"					\
	   "Curriculum Vitae for Philipp Geyer\n"			\
	   "\n"								\
	   "Output options\n"						\
	   " -p\tPersonal Information\n"				\
	   " -e\tExperience\n"						\
	   " -s\tSkills\n"						\
	   " -q\tQualifications\n"					\
	   " -l\tLanguages\n"						\
	   " -i\tInterests\n"						\
	   " -c\tContact\n"						\
	   "\n", name);
}

#define CV_PARAGRAPH(NUM)				\
    optHandled = 1; printf("\n%s\n", cv_org##NUM);

int main(int argc, char** argv)
{
    int opt;
    char optHandled = 0;
    
    while( (opt = getopt(argc, argv, "pesqlich")) != -1 )
    {
	switch( opt )
	{	
	case 'p':
	    CV_PARAGRAPH(00); break;
	case 'e':
	    CV_PARAGRAPH(01); break;
	case 's':
	    CV_PARAGRAPH(02); break;
	case 'q':
	    CV_PARAGRAPH(03); break;
	case 'l':
	    CV_PARAGRAPH(04); break;
	case 'i':
	    CV_PARAGRAPH(05); break;
	case 'c':
	    break;
	    
	case 'h':
	default:
	    // this is handled below with !optHandled
	    break;
	}
    }

    if( !optHandled )
    {
	printHelp(argv[0]);
    }
    
    
    return 0;
}
