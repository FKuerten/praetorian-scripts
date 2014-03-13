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

TRANSITIVE_STATIC_LIBRARIES:=$(shell ./scripts/findTransitive.sh . STATIC_LIBRARIES)
TRANSITIVE_DYNAMIC_LIBRARIES:=$(shell ./scripts/findTransitive.sh . DYNAMIC_LIBRARIES)
TRANSITIVE_LIBRARIES:=$(shell ./scripts/findTransitive.sh . LIBRARIES)
TRANSITIVE_DEPENDENCIES:=$(shell ./scripts/findTransitive.sh . DEPENDENCIES)

iftrue ${TRANSITIVE_DEPENDENCIES}
	MODULE_LIBRARY_PATH:=../${TRANSITIVE_DEPENDENCIES}/target
	MODULE_LIB_PATH:=$(addprefix -L, ${MODULE_LIBRARY_PATH})
	DEP_MEGA_DEBUG:=$(shell ./scripts/expandMegaObjects.sh debug ${TRANSITIVE_DEPENDENCIES})
	DEP_MEGA_NODEBUG:=$(shell ./scripts/expandMegaObjects.sh nodebug ${TRANSITIVE_DEPENDENCIES})
else
	MODULE_LIBRARY_PATH:=
	MODULE_LIB_PATH:=
	DEP_MEGA_DEBUG:=
	DEP_MEGA_NODEBUG:=
endif

STATIC_LIBS:=$(addprefix -l, ${TRANSITIVE_STATIC_LIBRARIES})
DYNAMIC_LIBS:=$(addprefix -l, ${TRANSITIVE_DYNAMIC_LIBRARIES})
LIBS:=$(addprefix -l, ${TRANSITIVE_LIBRARIES})
DEP_LIBS_NODEBUG:=$(addprefix -l, ${TRANSITIVE_DEPENDENCIES})
DEP_LIBS_DEBUG:=$(addsuffix -debug, ${DEP_LIBS_NODEBUG})
