#!/usr/bin/env bash

# Release changed charts with updated version inside Chart.yaml only(!)

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_CHART_RELEASER_VERSION=v1.2.1

show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help               Display help
    -v, --version            The chart-releaser version to use (default: $DEFAULT_CHART_RELEASER_VERSION)"
        --config             The path to the chart-releaser config file
    -d, --charts-dir         The charts directory (default: charts)
    -u, --charts-repo-url    The GitHub Pages URL to the charts repo (default: https://<owner>.github.io/<repo>)
    -o, --owner              The repo owner
    -r, --repo               The repo name
EOF
}

main() {
    local version="$DEFAULT_CHART_RELEASER_VERSION"
    local config=
    local charts_dir=charts
    local owner=
    local repo=
    local charts_repo_url=

    parse_command_line "$@"

    : "${CR_TOKEN:?Environment variable CR_TOKEN must be set}"

    local target_folders=()

    print_line_separator
    echo 'Find all dependencies. Split folders in two lists'
    mapfile -t dependencies< <(find_dependency_folders)
    mapfile -t all_charts_folders< <(find "$charts_dir" -maxdepth 2 -type f -name Chart.yaml | awk -F / '{print $2}')

    print_line_separator
    echo "Realise dependencies first: " "${dependencies[@]}"
    release_charts_inside_folders "${dependencies[@]}"
    release_charts_inside_folders "${all_charts_folders[@]}"
}

print_line_separator() {
    echo "============================================="
}

# find_dependencies names in $charts_dir folder and print multiline
find_dependency_folders() {
    mapfile -t dependencies< <(awk '/dependencies:/,/name:/{print $0}' $charts_dir/*/Chart.yaml | awk -F ": " '/name/{print $2}')
    for dependency in "${dependencies[@]}"; do
        folder_name=$(grep "^name: $dependency" $charts_dir/*/Chart.yaml | awk -F / '{print $2}')
        [[ ! "${target_folders[*]}" =~  $folder_name ]] && target_folders+=("$folder_name") && echo "$folder_name"
    done
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
    git describe --tags --abbrev=0 --match="$name*"
}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            --config)
                if [[ -n "${2:-}" ]]; then
                    config="$2"
                    shift
                else
                    echo "ERROR: '--config' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -v|--version)
                if [[ -n "${2:-}" ]]; then
                    version="$2"
                    shift
                else
                    echo "ERROR: '-v|--version' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -d|--charts-dir)
                if [[ -n "${2:-}" ]]; then
                    charts_dir="$2"
                    shift
                else
                    echo "ERROR: '-d|--charts-dir' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -u|--charts-repo-url)
                if [[ -n "${2:-}" ]]; then
                    charts_repo_url="$2"
                    shift
                else
                    echo "ERROR: '-u|--charts-repo-url' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -o|--owner)
                if [[ -n "${2:-}" ]]; then
                    owner="$2"
                    shift
                else
                    echo "ERROR: '--owner' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -r|--repo)
                if [[ -n "${2:-}" ]]; then
                    repo="$2"
                    shift
                else
                    echo "ERROR: '--repo' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done

    if [[ -z "$owner" ]]; then
        echo "ERROR: '-o|--owner' is required." >&2
        show_help
        exit 1
    fi

    if [[ -z "$repo" ]]; then
        echo "ERROR: '-r|--repo' is required." >&2
        show_help
        exit 1
    fi

    if [[ -z "$charts_repo_url" ]]; then
        charts_repo_url="https://$owner.github.io/$repo"
    fi
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
            if [[ -n "$config" ]]; then
                args+=(--config "$config")
            fi

            echo "Packaging chart folder '$folder'..."
            cr package "${args[@]}"
        else
            echo "Chart '$folder' no longer exists in repo. Skipping it..."
        fi
    done
}

release_charts() {
    local args=(-o "$owner" -r "$repo" -c "$(git rev-parse HEAD)")
    if [[ -n "$config" ]]; then
        args+=(--config "$config")
    fi

    echo 'Releasing charts...'
    cr upload "${args[@]}"
}

update_index() {
    local args=(-o "$owner" -r "$repo" -c "$charts_repo_url" --push)
    if [[ -n "$config" ]]; then
        args+=(--config "$config")
    fi

    echo 'Updating charts repo index...'
    cr index "${args[@]}"
}

main "$@"
