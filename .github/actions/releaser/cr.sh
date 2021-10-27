#!/usr/bin/env bash

# Release changed charts with updated version inside Chart.yaml only(!)

set -o errexit
set -o nounset
set -o pipefail

main() {
    local version=${VERSION:-v1.2.1}
    local charts_dir=${CHART_DIR:-charts}
    local charts_repo_url=${CHARTS_REPO_URL:-}
    local target=("$@")
    local owner=${OWNER:-}
    local repo=${REPO:-}

    : "${CR_TOKEN:?Environment variable CR_TOKEN must be set}"

    print_line_separator
    echo 'Found target folders for release...'
    if [[ -z "${target[*]}" ]]; then
        mapfile -t target< <(find "$charts_dir" -maxdepth 2 -type f -name Chart.yaml | awk -F / '{print $2}')
    fi

    print_line_separator
    echo "Target folders: " "${target[@]}"
    release_charts_inside_folders "${target[@]}"
}

print_line_separator() {
    echo "============================================="
}

release_charts_inside_folders() {
    local folders=("$@")
    local changed_charts=()

    # form list of folder which was changed
    for folder in "${folders[@]}"; do
        print_line_separator
        local chart_name
        local tag

        echo "Looking up latest release tag for \"$charts_dir/$folder/Chart.yaml\""
        chart_name=$(awk '/^name/{print $2}' "$charts_dir/$folder/Chart.yaml")

        # if chart is not released or folder has change, then remember as changed_charts
        if [[ ! "$(git tag -l "$chart_name*")" ]] || has_changed "$folder"; then
            changed_charts+=("$folder")
        fi
    done
    echo "changed charts: " "${changed_charts[@]}"

    # continue only with changed charts
    if [[ -n "${changed_charts[*]}" ]]; then
        install_chart_releaser
        cleanup_releaser
        package_charts "${changed_charts[@]}"
        release_charts
        update_index
    else
        echo "Nothing to do. No chart changes detected."
    fi
}

# check if release version and chart version is diffrent
has_changed() {
    local folder=$1
    local chart_name
    chart_name=$(awk '/^name/{print $2}' "$charts_dir/$folder/Chart.yaml")
    tag=$(get_latest_tag "$chart_name")
    changed_files=$(git diff --find-renames --name-only "$tag" -- "$charts_dir/$folder")

    echo "Looking for versions..."
    tag_version=$(echo "$tag" | awk -F '-' '{print $NF}') # sample-0.1.1 | 0.1.1
    chart_version=$(awk '/^version: /{print $2}' "$charts_dir/$folder/Chart.yaml")
    echo "version from tag: $tag_version"
    echo "version from chart: $chart_version"

    if [[ "$tag_version" != "$chart_version" ]] && [[ -n "$changed_files" ]]; then
        return 0
    fi
    return 1
}

get_latest_tag(){
    local name=$1

    git fetch --tags > /dev/null 2>&1
    git describe --tags --abbrev=0 --match="$name*" "$(git rev-list --tags --max-count=1)"
}

install_chart_releaser() {
    print_line_separator
    if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
        echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
        exit 1
    fi

    local arch
    arch=$(uname -m)

    local cache_dir="$RUNNER_TOOL_CACHE/ct/$version/$arch"
    if [[ ! -d "$cache_dir" ]]; then
        mkdir -p "$cache_dir"

        echo "Installing chart-releaser..."
        curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/$version/chart-releaser_${version#v}_linux_amd64.tar.gz"
        tar -xzf cr.tar.gz -C "$cache_dir"
        rm -f cr.tar.gz

        echo 'Adding cr directory to PATH...'
        export PATH="$cache_dir:$PATH"
    fi
}

cleanup_releaser() {
    rm -rf .cr-release-packages
    mkdir -p .cr-release-packages

    rm -rf .cr-index
    mkdir -p .cr-index
}

package_charts() {
    print_line_separator
    local changed_charts=("$@")
    for chart in "${changed_charts[@]}"; do
        folder="$charts_dir/$chart"
        if [[ -d "$folder" ]]; then
            local args=("$folder" --package-path .cr-release-packages)

            echo "Packaging chart folder '$folder'..."
            cr package "${args[@]}"
        else
            echo "Chart '$folder' no longer exists in repo. Skipping it..."
        fi
    done
}

release_charts() {
    local args=(-o "$owner" -r "$repo" -c "$(git rev-parse HEAD)")

    echo 'Releasing charts...'
    cr upload "${args[@]}"
}

update_index() {
    local args=(-o "$owner" -r "$repo" -c "$charts_repo_url" --push)

    echo 'Updating charts repo index...'
    cr index "${args[@]}"
}

main "$@"
