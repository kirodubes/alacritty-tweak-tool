#!/bin/bash
set -euo pipefail
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="${SCRIPT_DIR}/common"

# shellcheck source=common/common.sh
source "${COMMON_DIR}/common.sh"

clean_pycache() {
    log_section "Cleaning __pycache__"

    local found
    found=$(find "${SCRIPT_DIR}" -type d -name "__pycache__" 2>/dev/null)

    if [[ -n "${found}" ]]; then
        find "${SCRIPT_DIR}" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
        log_success "__pycache__ removed"
    else
        log_info "No __pycache__ found"
    fi
}

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
    clean_pycache
    ensure_git_remote_configured
    git_pull
    git_commit_and_push

    log_success "$(basename "$0") done"
}

main "$@"
