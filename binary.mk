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

MODULE_STATIC_NODEBUG_BINARY:=target/${MODULE_NAME}-static
MODULE_STATIC_DEBUG_BINARY:=target/{MODULE_NAME}-static-debug
MODULE_DYNAMIC_NODEBUG_BINARY:=target/{MODULE_NAME}-dynamic
MODULE_DYNAMIC_DEBUG_BINARY:=target/${MODULE_NAME}-dynamic-debug
MODULE_MEGA_OBJECT_NODEBUG_BINARY:=target/${MODULE_NAME}-mega
MODULE_MEGA_OBJECT_DEBUG_BINARY:=target/${MODULE_NAME}-mega-debug

$(phony binaries): ${MODULE_STATIC_NODEBUG_BINARY} ${MODULE_STATIC_DEBUG_BINARY} \
                   ${MODULE_DYNAMIC_NODEBUG_BINARY} ${MODULE_DYNAMIC_DEBUG_BINARY} \
                   ${MODULE_MEGA_OBJECT_NODEBUG_BINARY} ${MODULE_MEGA_OBJECT_DEBUG_BINARY}

NEEDED_OBJECTS_STATIC_NODEBUG:=$(infer_objects target/objects-static-nodebug/cli/main.o++, ${OBJECTS_STATIC_NODEBUG})
NEEDED_OBJECTS_STATIC_DEBUG:=$(infer_objects target/objects-static-debug/cli/main.o++, ${OBJECTS_STATIC_DEBUG})

# static binaries, nodebug and debug versions
${MODULE_STATIC_NODEBUG_BINARY}: ${NEEDED_OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${MODULE_LIB_PATH} \
	       ${NEEDED_OBJECTS_STATIC_NODEBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	                    ${LIBS}\
	                    ${DEP_LIBS_NODEBUG}\
	       -Wl,-Bdynamic ${DYNAMIC_LIBS}\
	       -o ${output}

${MODULE_STATIC_DEBUG_BINARY}: ${NEEDED_OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${MODULE_LIB_PATH} \
	       ${NEEDED_OBJECTS_STATIC_DBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	                    ${LIBS}\
	                    ${DEP_LIBS_DEBUG}\
	       -Wl,-Bdynamic ${DYNAMIC_LIBS}\
	       -o ${output}

${MODULE_DYNAMIC_NODEBUG_BINARY} : ${NEEDED_OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${MODULE_LIB_PATH} \
	       ${NEEDED_OBJECTS_STATIC_NODEBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	       -Wl,-Bdynamic ${LIBS}\
	                     ${DEP_LIBS_NODEBUG}\
	                     ${DYNAMIC_LIBS}\
	       -o ${output}

${MODULE_DYNAMIC_DEBUG_BINARY} : ${NEEDED_OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${MODULE_LIB_PATH} \
	       ${NEEDED_OBJECTS_STATIC_DEBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	       -Wl,-Bdynamic ${LIBS}\
	                     ${DEP_LIBS_DEBUG}\
	                     ${DYNAMIC_LIBS}\
	       -o ${output}

${MODULE_MEGA_OBJECT_NODEBUG_BINARY}: ${NEEDED_OBJECTS_STATIC_NODEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${NEEDED_OBJECTS_STATIC_NODEBUG}\
	       ${DEP_MEGA_NODEBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	                    ${LIBS}\
	       -Wl,-Bdynamic ${DYNAMIC_LIBS}\
	       -o ${output}

${MODULE_MEGA_OBJECT_DEBUG_BINARY}: ${NEEDED_OBJECTS_STATIC_DEBUG}
	@if [ -e ${output} ]; then rm ${output}; echo "rm ${output}"; fi
	${CXX} ${LDFLAGS}\
	       ${NEEDED_OBJECTS_STATIC_DEBUG}\
	       ${DEP_MEGA_DEBUG}\
	       -Wl,-Bstatic ${STATIC_LIBS}\
	                    ${LIBS}\
	       -Wl,-Bdynamic ${DYNAMIC_LIBS}\
	       -o ${output}
