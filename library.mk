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

MODULE_STATIC_NODEBUG_LIBRARY:=lib${MODULE_NAME}.a
MODULE_STATIC_DEBUG_LIBRARY:=lib${MODULE_NAME}-debug.a
MODULE_DYNAMIC_NODEBUG_LIBRARY:=lib${MODULE_NAME}.so
MODULE_DYNAMIC_DEBUG_LIBRARY:=lib${MODULE_NAME}-debug.so

$(phony libraries): target/${MODULE_STATIC_NODEBUG_LIBRARY} target/${MODULE_STATIC_DEBUG_LIBRARY} target/${MODULE_DYNAMIC_NODEBUG_LIBRARY} target/${MODULE_DYNAMIC_DEBUG_LIBRARY}

target/${MODULE_STATIC_NODEBUG_LIBRARY}: ${OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${AR} ${ARFLAGS} ${output} ${OBJECTS}

target/${MODULE_STATIC_DEBUG_LIBRARY}: ${OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${AR} ${ARFLAGS} ${output} ${OBJECTS}

target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} target/${MODULE_DYNAMIC_NODEBUG_LIBRARY} : ${OBJECTS_DYNAMIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS} ${CXXFLAGS} ${CXXFLAGS_DYNAMIC_NODEBUG} -shared -Wl,-soname,lib${MODULE_NAME}.${MODULE_MAJOR_VERSION} -o ${output} ${inputs}
	&ln -sr target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}
	&ln -sr target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} target/${MODULE_DYNAMIC_NODEBUG_LIBRARY}

target/${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} target/${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} target/${MODULE_DYNAMIC_DEBUG_LIBRARY} : ${OBJECTS_DYNAMIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${CXXFLAGS} ${CXXFLAGS_DYNAMIC_DEBUG} -shared -Wl,-soname,lib${MODULE_NAME}-debug.${MODULE_MAJOR_VERSION} -o ${output} ${inputs}
	&ln -sr target/${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}.${MODULE_MINOR_VERSION} target/${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION}
	&ln -sr target/${MODULE_DYNAMIC_DEBUG_LIBRARY}.${MODULE_MAJOR_VERSION} target/${MODULE_DYNAMIC_DEBUG_LIBRARY}
