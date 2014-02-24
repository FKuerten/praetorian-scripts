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

SRC_FOLDER="src/main/c++"
TARGET_FOLDER="target/objects"
FILES=$(find ${SRC_FOLDER} -type f -name "*.c++")

for FILE in ${FILES}; do
    PACKAGE_FILE_EXT=${FILE#src/main/c++*}
    PACKAGE_FILE=${PACKAGE_FILE_EXT%.c++}
    OBJECT="${PACKAGE_FILE}.o++"
    #echo ${FILE}
    #echo ${PACKAGE_FILE_EXT}
    #echo ${PACKAGE_FILE}
    TARGET_FILE="${TARGET_FOLDER}${OBJECT}"
    TARGET_PACKAGE=$(dirname ${TARGET_FILE})
    mkdir -p ${TARGET_PACKAGE}
    echo "${TARGET_FILE}"
done

