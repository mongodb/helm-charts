#!/bin/bash
set -uxo pipefail

# forked
git remote add mongo https://github.com/mongodb/helm-charts.git
git fetch mongo

CHART_DIRS="$(git diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" mongo/main -- charts | grep -i chart.yaml | xargs -r dirname)"
KUBEVAL_VERSION="0.15.0"
SCHEMA_LOCATION="https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/"

# install kubeval
curl --silent --show-error --fail --location --output /tmp/kubeval.tar.gz "https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz"
tar -xf /tmp/kubeval.tar.gz kubeval

# validate charts
helm repo add mongodb https://mongodb.github.io/helm-charts
for CHART_DIR in ${CHART_DIRS}; do
  if [[ ! -d "$CHART_DIR" ]]; then
    continue
  fi
  helm dependency update "${CHART_DIR}"
  helm template "${CHART_DIR}" | ./kubeval --strict --ignore-missing-schemas --kubernetes-version "${KUBERNETES_VERSION#v}" --schema-location "${SCHEMA_LOCATION}"
done
