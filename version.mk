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


# This is responsible for creating a version header
target/generated/version.h++: target/generated/version.h++.auto
    @if [ ! -e target/generated ]; then mkdir -p target/generated; echo "mkdir -p target/generated"; fi
    @if [ -e ${output} ] && diff --brief ${input} ${output} >/dev/null ; then \
        true; \
    else \
        echo "cp ${input} ${output}"; \
        cp ${input} ${output}; \
    fi

target/generated/version.h++.auto: FORCE scripts/generateVersionH++.sh
    @if [ ! -e target/generated ]; then mkdir -p target/generated; echo "mkdir -p target/generated"; fi
    @./scripts/generateVersionH++.sh ${MODULE_NAME} > ${output}
    @if [ -e target/generated/version.h++ ] && diff --brief ${output} target/generated/version.h++ >/dev/null ; then \
        true; \
    else \
        echo "./scripts/generateVersionH++.sh ${MODULE_NAME} > ${output}"; \
    fi
