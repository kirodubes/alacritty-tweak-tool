#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="${SCRIPT_DIR}"

git_commit_and_push() {
    local branch

    log_section "Git add / commit / push"
    git add --all .

    if [[ -z "$(git status --porcelain)" ]]; then
        log_info "Nothing to commit — working tree clean"
    else
        git commit -m "update" || log_error "Git commit failed"
    fi

    branch="$(git rev-parse --abbrev-ref HEAD)"

    if ! git push -u origin "${branch}"; then
        log_warn "Push rejected — rebasing on remote changes and retrying"
        git pull --rebase origin "${branch}" || { log_error "Rebase failed — resolve conflicts manually"; return 1; }
        git push -u origin "${branch}" || log_error "Git push failed after rebase"
    fi
}

git_pull() {
    log_section "Git pull"
    git -C "${SCRIPT_DIR}" pull || log_warn "Git pull failed — continuing with local state"
}

ensure_git_remote_configured() {
    local remote_url
    remote_url="$(git -C "${SCRIPT_DIR}" remote get-url origin 2>/dev/null || true)"
    if [[ "${remote_url}" != *"github.com-edu"* ]]; then
        log_section "Git remote not configured — running setup.sh first"
        bash "${SCRIPT_DIR}/setup.sh"
    fi
}


main() {


    ensure_git_remote_configured
    git_pull
    git_commit_and_push

    echo
    tput setaf 6
    echo "##############################################################"
    echo "###################  $(basename "$0") done"
    echo "##############################################################"
    tput sgr0
    echo
}

main "$@"

echo "################################################################"
echo "###################    Git Push Done      ######################"
echo "################################################################"
