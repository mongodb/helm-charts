#!/bin/bash
set -euxo pipefail

# Helper script to automate OpsManager Key creating

# MongoDB name and namespace
MONGODB_NAMESPACE=mongodb
MONGODB_NAME=mdbreplset

# Information about Ops Manager deployment
OPS_MANAGER_NAMESPACE=opsmanager
OPS_MANAGER_HELM_RELEASE_NAME=opsmanager

# Name of Ops Manager org where MongoDB will be dployed
OPS_MANAGER_ORG_NAME=DemoOrg


# Set up cert-manager: 
# follow https://cert-manager.io/docs/installation

# helm repo add jetstack https://charts.jetstack.io
# helm repo update

# helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.0.4 --set installCRDs=true --create-namespace

# create Root certificate

openssl genrsa -out ca.key 2048
COMMON_NAME=*.svc.cluster.local
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${COMMON_NAME}" -days 3650 -reqexts v3_req -extensions v3_ca -out ca.crt

# Deploy all nessesary and required certificates for MongoDB
helm install certs .

# postprocess issued certificates and build pem files
for i in {0..2} 
do 
    kubectl get secret/${MONGODB_NAME}-${i} -o jsonpath='{.data.tls\.crt}' | base64 --decode > $MONGODB_NAME-${i}-pem
    kubectl get secret/${MONGODB_NAME}-${i} -o jsonpath='{.data.tls\.key}' | base64 --decode >> $MONGODB_NAME-${i}-pem
done

# Join all pem files into a secret that will be used by MongoDB
kubectl create secret generic ${MONGODB_NAME}-cert $(for i in {0..2}; do echo --from-file=${MONGODB_NAME}-${i}-pem; done;)

rm ${MONGODB_NAME}-*

# create mongoDB CA configmap
cat ca.crt > ca-pem
kubectl create configmap ${MONGODB_NAME}-ca --from-file=ca-pem