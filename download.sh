#!/bin/sh
# Search and download a suitable version of Z3

Z3_DOWNLOAD='http://research.microsoft.com/en-us/um/redmond/projects/z3/download.html'

# Is 64 bit?
M64=`uname -m | grep 64 > /dev/null && echo true || echo false`

# Select the correct URL
if $M64; then
URL=`wget -q "$Z3_DOWNLOAD" -O - | grep -o 'http:[^"]*' | grep '/z3[^/]*.\(tar.gz\|tgz\)$' | grep 64 | sort | tail -1`
else
URL=`wget -q "$Z3_DOWNLOAD" -O - | grep -o 'http:[^"]*' | grep '/z3[^/]*.\(tar.gz\|tgz\)$' | grep -v 64 | sort | tail -1`
fi
FILE=`echo "$URL" | grep -o '[^/]*$'`

# Get tar gz
if [ ! -f tarballs/$FILE ]; then
wget -O "tarballs/$FILE" "$URL" > /dev/stderr
fi
echo $FILE
