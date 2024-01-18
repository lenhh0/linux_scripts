#!/bin/bash -e
# Adding git branch on the bash command prompt
# Ref https://stackoverflow.com/questions/15883416/adding-git-branch-on-the-bash-command-prompt

GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
BASH_RC="${HOME}/.bashrc"

function install_tool() {
    # Already installed
    echo "*** Checking the prerequisted tools..."
    if command -v git &> /dev/null; then
        echo -e "\n**** Checking git\t\t\t\t\t\t\t[FOUND]"
        if command -v curl &> /dev/null; then
            echo -e "**** Checking curl\t\t\t\t\t\t\t[FOUND]"
            return
        fi
    fi

    local tools="git curl"
    for tool in ${tools[$@]}; do
        echo -e "\n**** Installing ${tool}..."
        set -x
        sudo apt install "${tool}"
    done
}

function main() {

    install_tool

    # Get the script from github
    echo -e "\n*** Getting git-prompt.sh script from github..."
    curl -L -o "${HOME}/.git-prompt.sh" "${GIT_PROMPT_URL}"

    echo -e "\n*** Backup ~/.bashrc..."
    timestamp=$(date +"%H:%M:%S_%d_%m_%Y")
    cp "${BASH_RC}" "${BASH_RC}_${timestamp}"

    # Update the PS1 at bashrc
    echo -e "\n*** Updating ~/.bashrc..."
    sed -i -r 's/(PS1='\''\$.*])/\1\\033[0;32m\$\(__git_ps1 \" \(\%s\)\"\)\\033[0m/' "${BASH_RC}"
    sed -i -r 's/(PS1='\''\$.*\h:\\w)/\1\$\(__git_ps1 \" \(\%s\)\"\)/' "${BASH_RC}"

    echo -e "\n*** Applying the git-prompt.sh..."
    echo -e "\n#Apply git prompt as ref at https://stackoverflow.com/questions/15883416/adding-git-branch-on-the-bash-command-prompt" >> "${BASH_RC}"
    echo "source ~/.git-prompt.sh" >> "${BASH_RC}"
    source "${BASH_RC}"

}

main