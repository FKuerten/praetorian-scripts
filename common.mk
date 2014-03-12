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
include config.mk
include scripts/cxx.mk
include scripts/transitive.mk

$(phony FORCE):
	@true

ARFLAGS:=crvs

include scripts/version.mk
include scripts/objectsMetaMakeppfile.mk
include target/metaObjects.mk
#DUMMY:=$(print $(shell mkdir --verbose --parents target/objects-${CXX_VARIANTS}))
include target/objects-${CXX_VARIANTS}/objects.mk

#
#	CPP Stuff
#

INCLUDEDIRS:=
# If we have transitive dependencies, include their headers
iftrue ${TRANSITIVE_DEPENDENCIES}
	INCLUDEDIRS+=../${TRANSITIVE_DEPENDENCIES}/src/main/c++
endif

# Include our generated sources
INCLUDEDIRS+=target/generated

# Include transitive dependencies generated sources
# (skipped for now)


CPPFLAGS+=-I${INCLUDEDIRS}

#LIBS+=$(addprefix -l,${TRANSITIVE_DEPENDENCIES})
#LDFLAGS+=-L${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/
#OWN_LIB_FILES=$(shell ./scripts/expandModules.sh ${TRANSITIVE_DEPENDENCIES})

#iftrue ${DEPENDENCIES}
#	DEPENDENCY_FILES:=${CURDIR}/../${TRANSITIVE_DEPENDENCIES}/target/dependencies
#	DEPLIBS=$(shell cat ${DEPENDENCY_FILES})
#else
#	DEPENDENCY_FILES:=
#	DEPLIBS:=
#endif

OBJECTS_STATIC_NODEBUG:=$(shell scripts/findObjects.sh . static-nodebug)
OBJECTS_STATIC_DEBUG:=$(shell scripts/findObjects.sh . static-debug)
OBJECTS_DYNAMIC_NODEBUG:=$(shell scripts/findObjects.sh . dynamic-nodebug)
OBJECTS_DYNAMIC_DEBUG:=$(shell scripts/findObjects.sh . dynamic-debug)

#ALLLIBS=${LIBS} ${DEPLIBS}
#
#target/dependencies: ${DEPENDENCY_FILES}
#    echo ${ALLLIBS} > ${output}

load_makefile ../${TRANSITIVE_DEPENDENCIES}
