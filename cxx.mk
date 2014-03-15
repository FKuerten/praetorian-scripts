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
#	CXX stuff
#

#Warnings
CXX_WARNINGS=-Wall -Wdisabled-optimization -Wfloat-equal -Wold-style-cast
CXX_WARNINGS+=-Wsign-conversion -Wsign-promo -Wswitch-default
CXX_WARNINGS+=-Wzero-as-null-pointer-constant -Wuseless-cast
CXX_WARNINGS+=-Wconversion -Wconversion-extra -Wconversion-null -Wshorten-64-to-32

# Some special flags
CXXFLAGS:=--std=${CXX_STANDARD} ${CXX_WARNINGS} -Werror
CXXFLAGS_STATIC:=
CXXFLAGS_DYNAMIC:=-fPIC
CXXFLAGS_DEBUG:=-g -O0 -DDEBUG
CXXFLAGS_NODEBUG:=-O2 -DNDEBUG
CXXFLAGS_STATIC_NODEBUG:=${CXXFLAGS_STATIC} ${CXXFLAGS_NODEBUG}
CXXFLAGS_STATIC_DEBUG:=${CXXFLAGS_STATIC} ${CXXFLAGS_DEBUG}
CXXFLAGS_DYNAMIC_NODEBUG:=${CXXFLAGS_DYNAMIC} ${CXXFLAGS_NODEBUG}
CXXFLAGS_DYNAMIC_DEBUG:=${CXXFLAGS_DYNAMIC} ${CXXFLAGS_DEBUG}
CXX_VARIANTS:=static-debug static-nodebug dynamic-debug dynamic-nodebug

