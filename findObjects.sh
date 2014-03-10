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
MODULEDIR="$1"
VARIANT="$2"
SRC_FOLDER="${MODULEDIR}/src/main/c++"
TARGET_FOLDER="${MODULEDIR}/target/objects-${VARIANT}"
FILES=$(find -L ${SRC_FOLDER} -type f -name "*.c++")

for FILE in ${FILES}; do
    PACKAGE_FILE_EXT=${FILE#${SRC_FOLDER}*}
    PACKAGE_FILE=${PACKAGE_FILE_EXT%.c++}
    OBJECT="${PACKAGE_FILE}.o++"
    #echo ${FILE}
    #echo ${PACKAGE_FILE_EXT}
    #echo ${PACKAGE_FILE}
    echo "${TARGET_FOLDER}${OBJECT}"
done

