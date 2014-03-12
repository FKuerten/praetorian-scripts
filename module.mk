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
#	This should only be included by the module root Makeppfile
#

target/Makeppfile: scripts/targetMakeppfile.template
	@mkdir -p target
	cp ${input} ${output}

include scripts/common.mk

load_makefile target/Makeppfile

PROJECT_NAME=${MODULE_NAME}
include scripts/version.mk

load_makefile ${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}
