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

$(phony FORCE):
	@true

ARFLAGS:=crvs

#
#	Dependency and library stuff
#
#	This varies based on static and dynamic releases
#
# Input:
#   DEPENDENCIES          this lists only modules of this type they must
#                         be located in ../${NAME} they can be static,
#                         dynamic or objects
#   STATIC_LIBRARIES      these are libraries that must be linked
#                         statically
#   DYNAMIC_LIBRARIES     these are librearis that must be linked
#                         dynamically
#   LIBRARIES             these are libraries that can be linked either
#                         way
#
# The output obviously depends on the type of artifact we produce
# (though for now there is no difference between debug and nodebug
# versions)
#
# For the produced static libraries we need to list all required
# libraries and modules (libraries + headers)
#   TRANSITIVE_STATIC_LIBRARIES     these are the STATIC_LIBRARIES and
#                                   all TRANSITIVE_STATIC_LIBRARIES from
#                                   any dependency
#   TRANSITIVE_DYNAMIC_LIBRARIES    these are the DYNAMIC_LIBRARIES and
#                                   all TRANSITIVE_DYNAMIC_LIBRARIES
#                                   from any dependency
#   TRANSITIVE_LIBRARIES            these are the LIBRARIES and all
#                                   TRANSITIVE_LIBRARIES from any
#                                   dependency
#   TRANSITIVE_INCLUDES             these are our headers and all
#                                   TRANSITIVE_INCLUDES from any
#                                   dependency

include scripts/dependenciesMakeppfile.mk
include target/dependencies.mk
include scripts/version.mk


#
#	CPP Stuff
#

INCLUDEDIRS:=
# If we have transitive dependencies, include their headers
iftrue ${TRANSITIVE_INCLUDES}
	INCLUDEDIRS+=${MODULEDIR}/../${TRANSITIVE_INCLUDES}/src/main/c++
endif

# Include our generated sources
INCLUDEDIRS+=${MODULEDIR}/target/generated

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


OBJECTS_STATIC_NODEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} static-nodebug)
OBJECTS_STATIC_DEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} static-debug)
OBJECTS_DYNAMIC_NODEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} dynamic-nodebug)
OBJECTS_DYNAMIC_DEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} dynamic-debug)

#ALLLIBS=${LIBS} ${DEPLIBS}
#
#target/dependencies: ${DEPENDENCY_FILES}
#    echo ${ALLLIBS} > ${output}
