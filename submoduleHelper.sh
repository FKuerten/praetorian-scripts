#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

ROOT=$(git rev-parse --show-toplevel)
TEMP_FILE=$(mktemp)
git submodule foreach --recursive --quiet "PWD=\$(pwd); echo \${PWD#${ROOT}/} \$name \$sha1 \$toplevel" | sort -r > ${TEMP_FILE}

exec 3< ${TEMP_FILE}
while read -u 3 FULLPATH NAME SHA1 PARENT
do
    ./scripts/submoduleHelperSub.sh ${ROOT} ${FULLPATH} ${NAME} ${SHA1} ${PARENT}
    RETVAL=$?
    if [ ${RETVAL} -ne 0 ]; then
        exit ${RETVAL}
    fi
done
rm ${TEMP_FILE}
