#!/usr/bin/env bash

# Publish README.md to the gh-pages checkout so it becomes the GitHub Pages landing page.
# Relative chart links are rewritten to absolute GitHub URLs, as they do not resolve on the Pages site.
#
# Local usage (PAGES_DIR must be a throwaway clone of the gh-pages branch):
#   git clone --branch gh-pages git@github.com:mongodb/helm-charts.git /tmp/gh-pages
#   README_SRC=README.md PAGES_DIR=/tmp/gh-pages REPOSITORY=mongodb/helm-charts PUSH=false \
#     .github/actions/pages-readme/sync-readme.sh

set -o errexit
set -o nounset
set -o pipefail

readme_src=${README_SRC:?Environment variable README_SRC must be set}
pages_dir=${PAGES_DIR:?Environment variable PAGES_DIR must be set}
repository=${REPOSITORY:?Environment variable REPOSITORY must be set (owner/repo)}
source_ref=${SOURCE_REF:-$(git rev-parse --short HEAD)}
git_user_name=${GIT_USER_NAME:-github-actions[bot]}
git_user_email=${GIT_USER_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}
push=${PUSH:-true}
pages_branch=${PAGES_BRANCH:-gh-pages}
max_attempts=3

render_readme() {
    sed "s#](charts/#](https://github.com/${repository}/tree/main/charts/#g" "$readme_src" > "$pages_dir/README.md"
}

git_pages() {
    git -C "$pages_dir" -c user.name="$git_user_name" -c user.email="$git_user_email" "$@"
}

push_with_retry() {
    local attempt
    for ((attempt = 1; attempt <= max_attempts; attempt++)); do
        if git_pages push origin "HEAD:${pages_branch}"; then
            return 0
        fi
        echo "Push rejected (attempt ${attempt}/${max_attempts}), rebasing onto ${pages_branch}"
        git_pages pull --rebase origin "$pages_branch"
    done
    return 1
}

main() {
    render_readme

    if git_pages diff --quiet -- README.md; then
        echo "${pages_branch} README is up to date"
        return 0
    fi

    git_pages add README.md
    git_pages commit --message "Sync README from main@${source_ref}"

    if [[ "$push" != "true" ]]; then
        echo "PUSH=${push}: committed locally, not pushing"
        return 0
    fi

    push_with_retry
}

main
