#!/usr/bin/env bash

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

VARIANT="$1"
shift
for MODULE in "$@"; do
    case ${VARIANT} in
        static-nodebug*)
            echo "../${MODULE}/target/lib${MODULE}.a"
            ;;
        static-debug*)
            echo "../${MODULE}/target/lib${MODULE}-debug.a"
            ;;
        static-nodebug*)
            echo "../${MODULE}/target/lib${MODULE}.so"
            ;;
        static-debug*)
            echo "../${MODULE}/target/lib${MODULE}-debug.so"
            ;;
    esac
done
