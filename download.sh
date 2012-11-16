#!/bin/sh
# Search and download a suitable version of Z3

Z3_DOWNLOAD='http://research.microsoft.com/en-us/um/redmond/projects/z3/download.html'

X64=`uname -m | grep 64 > /dev/null && echo x64 || echo '-v x64'`
OSX=`uname -s | grep Darwin > /dev/null && echo osx  || echo '-v osx'`

URL=`cat download-links.txt | grep $X64 | grep $OSX | head -1`
FILE=`echo "$URL" | grep -o '[^/]*$'`

# Get tar gz
if [ ! -f tarballs/$FILE ]; then
wget -O "tarballs/$FILE" "$URL" > /dev/stderr
fi
echo $FILE
