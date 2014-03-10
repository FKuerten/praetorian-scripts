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

CREATE_DIR:=$(shell if [ ! -e target ]; then mkdir -p target; echo "mkdir -p target"; fi)

# This recreates the Makeppfile responsible for building the makefile for building the objects
target/objectsMakeppfile.mk: target/objectsMakeppfile.mk.auto
	# We are checking if they are the same
    @if [ -e ${output} ] && diff --brief ${input} ${output} >/dev/null ; then \
        true; \
    else \
        echo "cp ${input} ${output}"; \
        cp ${input} ${output}; \
    fi

target/objectsMakeppfile.mk.auto: FORCE scripts/objectsMetaMakeppfile.sh scripts/objectsMakeppfile.mk.template
    @./scripts/objectsMetaMakeppfile.sh ${MODULEDIR} ${CXX_VARIANTS} > ${output}
    @if [ -e target/objectsMakeppfile.mk ] && diff --brief ${output} target/objectsMakeppfile.mk >/dev/null ; then \
        true; \
    else \
        echo "./scripts/objectsMetaMakeppfile.sh ${MODULEDIR} ${CXX_VARIANTS} > ${output}"; \
    fi
