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
shift
TEMPFILE=$(mktemp)
for DEPENDENCY in "$@"; do
    echo ${DEPENDENCY} >> ${TEMPFILE}
    SUB_DIR="${MODULEDIR}/../${DEPENDENCY}"
    CONFIG_FILE="${SUB_DIR}/config.mk"
    SUB_DEPENDENCIES=$(grep <${CONFIG_FILE} "^DEPENDENCIES=" | cut -d'=' -f2)
    $0 ${SUB_DIR} ${SUB_DEPENDENCIES} >> ${TEMPFILE}
done

cat ${TEMPFILE} | sort --unique
rm ${TEMPFILE}
