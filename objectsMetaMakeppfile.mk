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
#	This one is a bit crazy.
#   This makefile is responsible for creating the makefile to create the
#   makefiles to create the objects.
#   Confused?
#   It creates target/objectsMakeppfile.mk from
#   scripts/objectsMakeppfile.mk with scripts/objectsMetaMakeppfile.sh
#

CREATE_DIR:=($print $(shell if [ ! -e ${MODULEDIR}/target ]; then mkdir -p ${MODULEDIR}/target; echo "mkdir -p ${MODULEDIR}/target"; fi))

# This recreates the Makeppfile responsible for building the makefile for building the objects
${MODULEDIR}/target/objectsMakeppfile.mk: ${MODULEDIR}/target/objectsMakeppfile.mk.auto
	# We are checking if they are the same
    @if [ -e ${output} ] && diff --brief ${input} ${output} >/dev/null ; then \
        true; \
    else \
        echo "cp ${input} ${output}"; \
        cp ${input} ${output}; \
    fi

${MODULEDIR}/target/objectsMakeppfile.mk.auto: ${MODULEDIR}/scripts/objectsMetaMakeppfile.sh ${MODULEDIR}/scripts/objectsMakeppfile.mk.template
    @${MODULEDIR}/scripts/objectsMetaMakeppfile.sh ${MODULEDIR} ${CXX_VARIANTS} > ${output}
    @if [ -e ${MODULEDIR}/target/objectsMakeppfile.mk ] && diff --brief ${output} ${MODULEDIR}/target/objectsMakeppfile.mk >/dev/null ; then \
        true; \
    else \
        echo "${MODULEDIR}/scripts/objectsMetaMakeppfile.sh ${MODULEDIR} ${CXX_VARIANTS} > ${output}"; \
    fi
