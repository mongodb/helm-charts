#!/usr/bin/env bash
cluster_name=${1}
ATLAS_PUBLIC_KEY=avvfdcsk
ATLAS_PRIVATE_KEY=f5c7e562-4f4f-40dd-b60f-3b602f229a9f
ATLAS_ORG_ID=599eec849f78f769464d0dca
helm install $cluster_name \
    ./charts/atlas-cluster \
    --set atlas.publicApiKey=${ATLAS_PUBLIC_KEY} \
    --set atlas.privateApiKey=${ATLAS_PRIVATE_KEY} \
    --set atlas.orgId=${ATLAS_ORG_ID} \
    --set project.name=${cluster_name} \
    --set project.atlasProjectName=${cluster_name} \

