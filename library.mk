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
#   This should only be included by the module root Makeppfile
#
include scripts/common.mk

MODULE_STATIC_NODEBUG_LIBRARY:=target/lib${MODULE_NAME}.a
MODULE_STATIC_DEBUG_LIBRARY:=target/lib${MODULE_NAME}-debug.a
MODULE_DYNAMIC_NODEBUG_LIBRARY:=target/lib${MODULE_NAME}.so
MODULE_DYNAMIC_DEBUG_LIBRARY:=target/lib${MODULE_NAME}-debug.so
MODULE_MEGA_OBJECT_NODEBUG:=target/${MODULE_NAME}-mega.o
MODULE_MEGA_OBJECT_DEBUG:=target/${MODULE_NAME}-mega-debug.o

$(phony libraries): ${MODULE_STATIC_NODEBUG_LIBRARY} ${MODULE_STATIC_DEBUG_LIBRARY} \
                    ${MODULE_DYNAMIC_NODEBUG_LIBRARY} ${MODULE_DYNAMIC_DEBUG_LIBRARY} \
                    ${MODULE_MEGA_OBJECT_NODEBUG} ${MODULE_MEGA_OBJECT_DEBUG}

# static libraries, nodebug and debug versions
${MODULE_STATIC_NODEBUG_LIBRARY}: ${OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${AR} ${ARFLAGS} ${output} ${inputs}

${MODULE_STATIC_DEBUG_LIBRARY}: ${OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${AR} ${ARFLAGS} ${output} ${inputs}

${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} ${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} ${MODULE_DYNAMIC_NODEBUG_LIBRARY} : ${OBJECTS_DYNAMIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS} ${CXXFLAGS} ${CXXFLAGS_DYNAMIC_NODEBUG} -shared -Wl,-soname,lib${MODULE_NAME}.so.${MODULE_MAJOR_VERSION} -o ${output} ${inputs}
	&ln -srf ${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} ${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}
	&ln -srf ${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} ${MODULE_DYNAMIC_NODEBUG_LIBRARY}

${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} ${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} ${MODULE_DYNAMIC_DEBUG_LIBRARY} : ${OBJECTS_DYNAMIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS} ${CXXFLAGS} ${CXXFLAGS_DYNAMIC_DEBUG} -shared -Wl,-soname,lib${MODULE_NAME}-debug.so.${MODULE_MAJOR_VERSION} -o ${output} ${inputs}
	&ln -srf ${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} ${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}
	&ln -srf ${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} ${MODULE_DYNAMIC_DEBUG_LIBRARY}

${MODULE_MEGA_OBJECT_NODEBUG}: ${OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${LD} --relocatable ${inputs} -o ${output}

${MODULE_MEGA_OBJECT_DEBUG}: ${OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${LD} --relocatable ${inputs} -o ${output}
