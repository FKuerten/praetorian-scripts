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
SCOPE="$2"

# start with this module
CONFIG_FILE="${MODULEDIR}/config.mk"
DEPENDENCIES=$(grep <${CONFIG_FILE} -E "^DEPENDENCIES.?=" | cut -d'=' -f2)
OURS=$(grep <${CONFIG_FILE} -E "^${SCOPE}.?=" | cut -d'=' -f2)

TRANSITIVE="${OURS}"

#echo "dependencies: ${DEPENDENCIES}" >&2
#echo "scope: ${SCOPE}" >&2
#echo "ours: ${OURS}" >&2

# recurse a bit
for DEPENDENCY in ${DEPENDENCIES}; do
    DEPENDENCY_DIR="${MODULEDIR}/../${DEPENDENCY}"
    SUB=$($0 ${DEPENDENCY_DIR} ${SCOPE})
    TRANSITIVE="${TRANSITIVE} ${SUB}"
done

# Clean up

clean () {
    echo "$@" | awk 'BEGIN { RS="[[:space:]]+"; ORS=" " } !x[$0]++'
}

TRANSITIVE=$(clean ${TRANSITIVE})
echo "${TRANSITIVE}"
