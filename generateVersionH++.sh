#!/usr/bin/env bash
PREFIX="$1"
if [ -z "${PREFIX}"] ; then
    echo "Need to specify a prefix to create a version header." >&2
    exit 1
fi

echo -n "#define ${PREFIX}_VERSION \""
git rev-parse HEAD | tr --delete "\n"
echo  "\""
echo -n "#define ${PREFIX}_VERSION_TAGS \""
git tag --points-at HEAD | tr "\n" " "
echo  "\""
echo -n "#define ${PREFIX}_VERSION_DESCRIBE \""
git describe HEAD | tr --delete "\n"
echo "\""
#
echo -n "#define ${PREFIX}_DIRTY_HEAD "
if [ `git diff HEAD | wc --chars` -gt 0 ]; then 
    echo true
else \
    echo false
fi
echo -n "#define ${PREFIX}_DIRTY_HASH \""
git diff HEAD | sha1sum | cut -d " " -f 1 | tr -d "\n"
echo  "\""
#

