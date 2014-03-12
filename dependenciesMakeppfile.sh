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
shift 1

# start with this module
CONFIG_FILE="${MODULEDIR}/config.mk"
DEPENDENCIES=$(grep <${CONFIG_FILE} -E "^DEPENDENCIES.?=" | cut -d'=' -f2)
STATIC_LIBRARIES=$(grep <${CONFIG_FILE} -E "^STATIC_LIBRARIES.?=" | cut -d'=' -f2)
DYNAMIC_LIBRARIES=$(grep <${CONFIG_FILE} -E "^DYNAMIC_LIBRARIES.?=" | cut -d'=' -f2)
LIBRARIES=$(grep <${CONFIG_FILE} -E "^LIBRARIES.?=" | cut -d'=' -f2)
echo "# our dependencies     : ${DEPENDENCIES}"
echo "# our static libraries : ${STATIC_LIBRARIES}"
echo "# our dynamic libraries: ${DYNAMIC_LIBRARIES}"
echo "# our libraries        : ${LIBRARIES}"
echo ""

TRANSITIVE_DEPENDENCIES="${DEPENDENCIES}"
TRANSITIVE_STATIC_LIBRARIES="${STATIC_LIBRARIES}"
TRANSITIVE_DYNAMIC_LIBRARIES="${DYNAMIC_LIBRARIES}"
TRANSITIVE_LIBRARIES="${LIBRARIES}"
TRANSITIVE_INCLUDES=""

# recurse a bit
TEMP_FILE=$(mktemp)
for DEPENDENCY in ${TRANSITIVE_DEPENDENCIES}; do
    DEPENDENCY_DIR="${MODULEDIR}/../${DEPENDENCY}"
    $0 ${DEPENDENCY_DIR} > ${TEMP_FILE}
    SUB_DEPENDENCIES=$(grep <${TEMP_FILE} -E "^TRANSITIVE_DEPENDENCIES.?=" | cut -d'=' -f2)
    SUB_STATIC_LIBRARIES=$(grep <${TEMP_FILE} -E "^TRANSITIVE_STATIC_LIBRARIES.?=" | cut -d'=' -f2)
    SUB_DYNAMIC_LIBRARIES=$(grep <${TEMP_FILE} -E "^TRANSITIVE_DYNAMIC_LIBRARIES.?=" | cut -d'=' -f2)
    SUB_LIBRARIES=$(grep <${TEMP_FILE} -E "^TRANSITIVE_LIBRARIES.?=" | cut -d'=' -f2)
    TRANSITIVE_DEPENDENCIES="${TRANSITIVE_DEPENDENCIES} ${SUB_DEPENDENCIES}"
    TRANSITIVE_STATIC_LIBRARIES="${TRANSITIVE_STATIC_LIBRARIES} ${SUB_STATIC_LIBRARIES}"
    TRANSITIVE_DYNAMIC_LIBRARIES="${TRANSITIVE_DYNAMIC_LIBRARIES} ${SUB_DYNAMIC_LIBRARIES}"
    TRANSITIVE_LIBRARIES="${TRANSITIVE_LIBRARIES} ${SUB_LIBRARIES}"
done
rm ${TEMP_FILE}

# Clean up

clean () {
    echo "$@" | awk 'BEGIN { RS="[[:space:]]+"; ORS=" " } !x[$0]++'
}

for DEPENDENCY in ${TRANSITIVE_DEPENDENCIES}; do
    #echo "\${MODULEDIR}/../${DEPENDENCY}/src/main/c++"
    TRANSITIVE_INCLUDES="${TRANSITIVE_INCLUDES}\${MODULEDIR}/../${DEPENDENCY}/src/main/c++ "
done

TRANSITIVE_DEPENDENCIES=$(clean ${TRANSITIVE_DEPENDENCIES})
TRANSITIVE_STATIC_LIBRARIES=$(clean ${TRANSITIVE_STATIC_LIBRARIES})
TRANSITIVE_DYNAMIC_LIBRARIES=$(clean ${TRANSITIVE_DYNAMIC_LIBRARIES})
TRANSITIVE_LIBRARIES=$(clean ${TRANSITIVE_LIBRARIES})

echo "#Transitive stuff:"
echo "TRANSITIVE_DEPENDENCIES:=${TRANSITIVE_DEPENDENCIES}"
echo "TRANSITIVE_STATIC_LIBRARIES:=${TRANSITIVE_STATIC_LIBRARIES}"
echo "TRANSITIVE_DYNAMIC_LIBRARIES:=${TRANSITIVE_DYNAMIC_LIBRARIES}"
echo "TRANSITIVE_LIBRARIES:=${TRANSITIVE_LIBRARIES}"
echo
echo "#Automatic derived:"
echo "TRANSITIVE_INCLUDES:=${TRANSITIVE_INCLUDES}"

