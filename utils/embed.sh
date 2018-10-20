#!/bin/bash

EFLAGS=

output_to_file() {
    FILE=$1
    NAME=$(basename ${FILE} | sed -e 's/\./_/g')

    echo ${EFLAGS} "const char* ${NAME} = \\" >> ${OUT}
    cat ${FILE} | grep -v "^#+" | sed -e 's/\"/\\\"/g' -e 's/^/\t\"/' -e 's/$/\\n\"\t\\/g' >> ${OUT}
    echo ${EFLAGS} ";" >> ${OUT}
    echo >> ${OUT}
    
}

IN=$1
OUT=src/${IN}.h
NAME=$(echo ${IN} | sed -e 's/\./_/g')

TMPDIR=$(mktemp -d)

cat ${IN} | grep -v "^#+" | grep -v "^$" | csplit -szf ${TMPDIR}/${IN} - "/^\* /+0" {*}

if [ -e ${OUT} ] ; then
    rm ${OUT} 
fi

for F in ${TMPDIR}/${IN}* ; do
    output_to_file ${F}
done
