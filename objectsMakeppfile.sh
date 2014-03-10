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
SPECIAL_FLAGS_NAME="$2"
SRC_FOLDER="${MODULEDIR}/src/main/c++"
FOLDERS=$(find -L ${SRC_FOLDER} -type d | grep -v "/\.")
MAKEPPFILE_TEMPLATE="${MODULEDIR}/scripts/MakeppfileForObjectsTemplate"

echo "MODULEDIR:=../.."
echo "include ../../config.mk"
echo "include ../../scripts/makefile.mk"

for FOLDER in ${FOLDERS}; do
    PACKAGE=${FOLDER#${SRC_FOLDER}*}
    #echo ${FOLDER}
    #echo ${PACKAGE}
    sed <${MAKEPPFILE_TEMPLATE} --expression="s!#PACKAGE#!${PACKAGE}!g" \
                                --expression="s!#SPECIAL_FLAGS_NAME#!${SPECIAL_FLAGS_NAME}!g"
done
