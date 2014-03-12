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

#
#   This file creates a makeppfile to create makeppfiles for the objects.
#
#

MODULEDIR="$1"
shift
VARIANTS="$@"
MAKEPPFILE_TEMPLATE="${MODULEDIR}/scripts/objectsMakeppfile.mk.template"

echo "MODULEDIR:=.."
echo "include ../config.mk"
echo "include ../scripts/common.mk"

for VARIANT in ${VARIANTS}; do
    FOLDER="objects-${VARIANT}"
    UPPERCASED=$(echo ${VARIANT} | tr [:lower:] [:upper:] | tr '-' '_')
    SPECIAL_FLAGS_NAME="CXXFLAGS_${UPPERCASED}"

    sed <${MAKEPPFILE_TEMPLATE} --expression="s!#FOLDER#!${FOLDER}!g" \
                                --expression="s!#SPECIAL_FLAGS_NAME#!${SPECIAL_FLAGS_NAME}!g"
done
