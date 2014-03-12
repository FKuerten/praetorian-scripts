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

    #echo ${HEAD_COMMIT} ${REMOTE_COMMIT} ${MERGE_BASE}

    FAST_FORWARD_PULL=0
    FAST_FORWARD_PUSH=0
    HEAD_AND_REMOTE_DIFFERENT=1
    if [ "${HEAD_COMMIT}" == "${REMOTE_COMMIT}" ] ; then
        HEAD_AND_REMOTE_DIFFERENT=0
    elif [ "${HEAD_COMMIT}" == "${MERGE_BASE}" ]; then
        FAST_FORWARD_PULL=1
    elif [ "${MERGE_BASE}" == "${REMOTE_COMMIT}" ]; then
        FAST_FORWARD_PUSH=1
    fi

    #echo ${FAST_FORWARD_PULL} ${FAST_FORWARD_PUSH} ${HEAD_AND_REMOTE_DIFFERENT}

    if [ ${DIRTY} -ne 0 ]; then
        echo -e "\t\e[0;31mNeeds manual work!\e[0m"
        echo -e "\tI can give you a \e[1mshell\e[0m to commit this, \e[1mskip\e[0m this submodule, \e[1mabort\e[0m or start \e[1mgit gui\e[0m."
        select COMMAND in "shell" "skip" "abort" "gui"; do
            case ${COMMAND} in
                shell)
                    echo -e "\tI am starting a sub shell for you in this submodule. Exiting will return to me."
                    bash --rcfile ${RC_FILE}
                    break;;
                skip)
                    exit 0;;
                abort)
                    echo -e "\tOkay, aborting."
                    exit 1;;
                gui)
                    git gui
                    break;;
            esac
        done
    elif [ ${FAST_FORWARD_PULL} -ne 0 ]; then
        echo -e "\tFast-forward \e[0;32mpull\e[0m possible."
        echo -e "\tI can give you a \e[1mshell\e[0m to do this, \e[1mskip\e[0m this submodule, \e[1mabort\e[0m or do the fast-forward \e[1mgit pull --ff-only\e[0m for you."
        select COMMAND in "shell" "skip" "abort" "pull"; do
            case ${COMMAND} in
                shell)
                    echo -e "\tI am starting a sub shell for you in this submodule. Exiting will return to me."
                    bash --rcfile ${RC_FILE}
                    break;;
                skip)
                    exit 0;;
                abort)
                    echo -e "\tOkay, aborting."
                    exit 1;;
                pull)
                    git pull --ff-only
                    break;;
            esac
        done
    elif [ ${FAST_FORWARD_PUSH} -ne 0 ]; then
        LOCAL_BRANCH=$(git branch --no-color | grep -E "^\*" | sed -e "s|^\* ||")
        REMOTE=$(git config --local --get branch.${LOCAL_BRANCH}.remote)
        echo -e "\tFast-forward \e[0;34mpush\e[0m possible."
        echo -e "\tI can give you a \e[1mshell\e[0m to do this, \e[1mskip\e[0m this submodule, \e[1mabort\e[0m or do the fast-forward \e[1mgit push ${REMOTE} ${LOCAL_BRANCH}\e[0m for you."
        select COMMAND in "shell" "skip" "abort" "push"; do
            case ${COMMAND} in
                shell)
                    echo -e "\tI am starting a sub shell for you in this submodule. Exiting will return to me."
                    bash --rcfile ${RC_FILE}
                    break;;
                skip)
                    exit 0;;
                abort)
                    echo -e "\tOkay, aborting."
                    exit 1;;
                push)
                    git push ${REMOTE} ${LOCAL_BRANCH}
                    break;;
            esac
        done
    elif [ ${HEAD_AND_REMOTE_DIFFERENT} -ne 0 ]; then
        echo -e "\tHEAD and remote are \e[0;31mdifferent\e[0m!"
    else
        break;
    fi
done
