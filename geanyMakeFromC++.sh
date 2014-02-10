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

#assume $1 contains a filename
SOURCEFILE="$1"
#echo ${SOURCEFILE}
SOURCEFILE_FULL=$(readlink -e ${SOURCEFILE})
SEARCH="src/main/c++/"
REPLACE="target/objects/"
TEMP="${SOURCEFILE_FULL/${SEARCH}/${REPLACE}}"
OBJECTFILE_FULL="${TEMP/.c++/.o++}"
OBJECTFILE_FULL="${OBJECTFILE_FULL/.h++/.o++}"
#echo ${OBJECTFILE_FULL}
DIR="$PWD"
#echo $DIR
OBJECTFILE=$(python -c "import os.path; print os.path.relpath('${OBJECTFILE_FULL}','${DIR}')")
#echo ${OBJECTFILE}

echo makepp ${OBJECTFILE}
exec makepp ${OBJECTFILE}
