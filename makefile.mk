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

# Start with no include directories
INCLUDEDIRS:=

# If we have dependencies, calculate transitive dependencies
iftrue ${DEPENDENCIES}
	TRANSITIVE_DEPENDENCIES=$(shell ${MODULEDIR}/scripts/findTransitiveDependencies.sh ${MODULEDIR} ${DEPENDENCIES})
else
	TRANSITIVE_DEPENDENCIES:=
endif

# If we have transitive dependencies, include their headers
iftrue ${TRANSITIVE_DEPENDENCIES}
	INCLUDEDIRS+=${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}/src/main/c++
endif

# Include our generated sources
INCLUDEDIRS+=${MODULEDIR}/target/generated

# Include transitive dependencies generated sources
# (skipped for now)


CPPFLAGS+=-I${INCLUDEDIRS}

PROJECT_NAME=${MODULE_NAME}
include scripts/objectsMakeppfile.mk
include scripts/version.mk

$(phony FORCE):
    @true

LIBS+=$(addprefix -l,${TRANSITIVE_DEPENDENCIES})
LDFLAGS+=-L${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/
OWN_LIB_FILES=$(shell ./scripts/expandModules.sh ${TRANSITIVE_DEPENDENCIES})

iftrue ${DEPENDENCIES}
	DEPENDENCY_FILES:=${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/dependencies
	DEPLIBS=$(shell cat ${DEPENDENCY_FILES})
else
	DEPENDENCY_FILES:=
	DEPLIBS:=
endif

load_makefile ${MODULEDIR}/target/objects/Makeppfile
load_makefile ${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}

OBJECTS:=$(shell ${MODULEDIR}/scripts/findObjects.sh)
ALLLIBS=${LIBS} ${DEPLIBS}

target/dependencies: ${DEPENDENCY_FILES}
    echo ${ALLLIBS} > ${output}
