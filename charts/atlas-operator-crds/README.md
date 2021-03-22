# Atlas Operator CRDs Helm Chart

A Helm chart for installing and upgrading Custom Resource Definitions (CRDs) for the Atlas Operator. These CRDs are 
required by the Atlas Operator to work. 

## Usage

Installing the CRDs into the Kubernetes Cluster:

```
helm repo add mongodb https://github.com/mongodb/helm-charts
helm install atlas-operator-crds mongodb/atlas-operator-crds
```

Upgrading the CRDs:

```
helm upgrade atlas-operator-crds mongodb/atlas-operator-crds
```