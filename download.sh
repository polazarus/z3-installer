#!/bin/sh
# Search, download and extract a suitable version of Z3

Z3_DOWNLOAD='http://research.microsoft.com/en-us/um/redmond/projects/z3/download.html'

# Is 64 bit?
M64=`uname -m | grep 64 > /dev/null && echo true || echo false`

# Get links
if [ ! -f .links ]; then
wget -q "$Z3_DOWNLOAD" -O - | grep -o 'http:[^"]*' > .links
fi

# Select the correct URL
if $M64; then
URL=`cat .links | grep '/z3[^/]*.\(tar.gz\|tgz\)$' | grep 64 | head -1`
else
URL=`cat .links | grep '/z3[^/]*.\(tar.gz\|tgz\)$' | grep -v 64 | head -1`
fi
FILE=`echo "$URL" | grep -o '[^/]*$'`

# Get tar gz
if [ ! -f $FILE ]; then
wget -O "$FILE" "$URL" > /dev/stderr
fi

# Extract Z3 files
if [ ! -d z3 ]; then
tar xzf "$FILE" z3 > /dev/stderr
# Z3 tar contents is wrongly dated
find z3 | xargs touch
fi
