# Atlas Operator CRDs Helm Chart

A Helm chart for installing and upgrading Custom Resource Definitions (CRDs) for the Atlas Operator. These CRDs are 
required by the Atlas Operator to work. 

## Usage

Installing the CRDs into the Kubernetes Cluster:

```
helm repo add mongodb https://mongodb.github.io/helm-charts
helm install mongodb-atlas-operator-crds mongodb/mongodb-atlas-operator-crds
```

Upgrading the CRDs:

```
helm upgrade mongodb-atlas-operator-crds mongodb/mongodb-atlas-operator-crds
```