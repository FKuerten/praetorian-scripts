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

#Warnings
CXX_WARNINGS=-Wall -Wdisabled-optimization -Wfloat-equal -Wold-style-cast
CXX_WARNINGS+=-Wsign-conversion -Wsign-promo -Wswitch-default
CXX_WARNINGS+=-Wzero-as-null-pointer-constant -Wuseless-cast

# Some special flags
CXXFLAGS:=--std=${CXX_STANDARD} ${CXX_WARNINGS} -Werror
CXXFLAGS_STATIC:=
CXXFLAGS_DYNAMIC:=-fPIC
CXXFLAGS_DEBUG:=-g -O0
CXXFLAGS_NODEBUG:=-O2
CXXFLAGS_STATIC_NODEBUG:=${CXXFLAGS_STATIC} ${CXXFLAGS_NODEBUG}
CXXFLAGS_STATIC_DEBUG:=${CXXFLAGS_STATIC} ${CXXFLAGS_DEBUG}
CXXFLAGS_DYNAMIC_NODEBUG:=${CXXFLAGS_DYNAMIC} ${CXXFLAGS_NODEBUG}
CXXFLAGS_DYNAMIC_DEBUG:=${CXXFLAGS_DYNAMIC} ${CXXFLAGS_DEBUG}
CXX_VARIANTS=static-debug static-nodebug dynamic-debug dynamic-nodebug
ARFLAGS:=crvs

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


OBJECTS_STATIC_NODEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} static-nodebug)
OBJECTS_STATIC_DEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} static-debug)
OBJECTS_DYNAMIC_NODEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} dynamic-nodebug)
OBJECTS_DYNAMIC_DEBUG:=$(shell ${MODULEDIR}/scripts/findObjects.sh ${MODULEDIR} dynamic-debug)
ALLLIBS=${LIBS} ${DEPLIBS}

target/dependencies: ${DEPENDENCY_FILES}
    echo ${ALLLIBS} > ${output}
