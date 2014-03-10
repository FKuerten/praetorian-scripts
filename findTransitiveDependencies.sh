#!/usr/bin/env bash
MODULEDIR="$1"
shift
TEMPFILE=$(mktemp)
for DEPENDENCY in "$@"; do
    echo ${DEPENDENCY} >> ${TEMPFILE}
    SUB_DIR="${MODULEDIR}/../${DEPENDENCY}"
    CONFIG_FILE="${SUB_DIR}/config.mk"
    SUB_DEPENDENCIES=$(grep <${CONFIG_FILE} "^DEPENDENCIES=" | cut -d'=' -f2)
    $0 ${SUB_DIR} ${SUB_DEPENDENCIES} >> ${TEMPFILE}
done

cat ${TEMPFILE} | sort --unique
rm ${TEMPFILE}
