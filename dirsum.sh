#!/bin/bash
# Script to compute rigorous recursive digest of  a directory
# author: vysakhpillai@gmail.com
# usage: ./dirsum <directory>
# notes:
#        digest will change even if file names or locations are changed
#
#        works even if a file name is given as input
#
#        to change the digest computation command, change the "DIGEST" variable.
#
#        The computed digest will be different from the one conputed with the actual
#        command since the script uses custom format
#
#        Possible (tested) commands are : md5sum, sha512sum, sha256sum, sha1sum, shasum, sha384sum, sha224sum


DIGEST=md5sum

if [ $# != 1 ];
then
        echo "usage: $(basename $0) <directory>"
        exit 1
else
        for file in $(find $1); do
                if [ ! -d $file ]; then
                        SUM=$($DIGEST $file):$SUM         # compute DIGEST of files and append it to SUM
                else
                        SUM=$(echo "$file"|$DIGEST):$SUM  # compute DIGEST of directory names and append it to SUM
                fi
        done
        echo $SUM | $DIGEST
fi
