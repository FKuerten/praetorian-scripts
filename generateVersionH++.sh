#!/usr/bin/env bash

#
#   Copyright 2014 Fabian "Praetorian" Kürten
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

PREFIX="$1"
if [ -z "${PREFIX}" ] ; then
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

