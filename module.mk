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

include scripts/makefile.mk

PROJECT_NAME=${MODULE_NAME}
include scripts/objectsMetaMakeppfile.mk
include scripts/version.mk

load_makefile target/objectsMakeppfile.mk
load_makefile target/objects-${CXX_VARIANTS}/Makeppfile
load_makefile ${MODULEDIR}/../${TRANSITIVE_DEPENDENCIES}
