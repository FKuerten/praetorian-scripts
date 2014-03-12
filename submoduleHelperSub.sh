#!/usr/bin/env bash

ROOT="$1"
FULLPATH="$2"
NAME="$3"
SHA1="$4"
PARENT="$5"

cd ${FULLPATH}

RC_FILE=$(mktemp)
trap "rm ${RC_FILE}" EXIT
cat << EOF > ${RC_FILE}
bash_prompt_command() {
    PS1="        submodule: \[\e[1;34m\]${FULLPATH}\[\e[0m\]\$ "
    PS2="        > "
    PS3="        "
    PS4="        + "
}
PROMPT_COMMAND="bash_prompt_command;"
EOF

# Main loop
while true; do
    echo "In submodule ${FULLPATH}"
    git fetch --all --quiet

    HEAD_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse @{u})

    git status --short | sed -e 's|^|\t|'
    $(git diff --quiet --exit-code)
    DIRTY=$?

    MERGE_BASE=$(git merge-base ${HEAD_COMMIT} ${REMOTE_COMMIT})

    FAST_FORWARD_PULL=0
    FAST_FORWARD_PUSH=0
    HEAD_AND_REMOTE_DIFFERENT=1
    if [ "${HEAD_COMMIT}" == "${REMOTE_COMMIT}" ] ; then
        # same
        HEAD_AND_REMOTE_DIFFERENT=0
    elif [ "${HEAD_COMMIT}" == "${MERGE_BASE}" ]; then
        echo -e "\tFast forward \e[0;32mpull\e[0m possible."
        FAST_FORWARD_PULL=1
    elif [ "${MERGE_BASE}" == "${REMOTE_COMMIT}" ]; then
        echo -e "\tFast forward \e[0;34m\]push\e[0m possible."
        FAST_FORWARD_PUSH=1
    else
        # different
        echo -e "\tHEAD and remote are \e[0;31mdifferent\e[0m!"
    fi

    if [ ${DIRTY} -ne 0 ]; then
        echo -e "\t\e[0;31mNeeds manual work!\e[0m"
        echo -e "\tI am starting a sub shell for you in this submodule. Exiting will return to me."
        bash --rcfile ${RC_FILE}
    elif [ ${FAST_FORWARD_PULL} ]; then
        true
    elif [ ${FAST_FORWARD_PUSH} ]; then
        true
    elif [ ${HEAD_AND_REMOTE_DIFFERENT} ]; then
        true
    else
        break;
    fi
done
