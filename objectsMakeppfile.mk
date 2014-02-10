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

CREATE_DIR:=$(shell if [ ! -e target/objects ]; then mkdir -p target/objects; echo "mkdir -p target/objects"; fi)

# This recreates the Makeppfile responsible for building the objects
target/objects/Makeppfile: target/objects/Makeppfile.auto
    @if [ ! -e target/objects ]; then mkdir -p target/objects; echo "mkdir -p target/objects"; fi
    @if [ -e ${output} ] && diff --brief ${input} ${output} >/dev/null ; then \
        true; \
    else \
        echo "cp ${input} ${output}"; \
        cp ${input} ${output}; \
    fi

target/objects/Makeppfile.auto: FORCE scripts/generateMakeppfileForObjects.sh scripts/MakeppfileForObjectsTemplate
    @if [ ! -e target/objects ]; then mkdir -p target/objects; echo "mkdir -p target/objects"; fi
    @./scripts/generateMakeppfileForObjects.sh > ${output}
    @if [ -e target/objects/Makeppfile ] && diff --brief ${output} target/objects/Makeppfile >/dev/null ; then \
        true; \
    else \
        echo "./scripts/generateMakeppfileForObjects.sh > ${output}"; \        
    fi
