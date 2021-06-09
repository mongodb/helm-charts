# MongoDB Atlas Operator Helm Chart

A Helm chart for installing and upgrading [MongoDB Atlas Operator](https://github.com/mongodb/mongodb-atlas-kubernetes). 
The Operator allows to manage resources from Atlas (projects, clusters, database users, etc) not leaving the Kubernetes cluster.

## Prerequisites

You need to install the [Atlas Operator CRDs](../atlas-operator-crds) first before installing the Operator.

## Usage

### Installing the Operator (in clusterwide mode) into the Kubernetes Cluster:

```
helm repo add mongodb https://mongodb.github.io/helm-charts
helm install atlas-operator --namespace=atlas-operator --create-namespace mongodb/mongodb-atlas-operator
```

### Installing the Operator (in namespaced mode - watching the self namespace) into the Kubernetes Cluster:

```
helm repo add mongodb https://mongodb.github.io/helm-charts
helm install atlas-operator --namespace=operator --set watchNamespaces=operator --create-namespace mongodb/mongodb-atlas-operator
```

### Installing the Operator (in clusterwide mode) and configure the Global API Secret:

```
helm repo add mongodb https://mongodb.github.io/helm-charts
helm install atlas-operator --namespace=atlas-operator --create-namespace --set globalConnectionSecret.publicApiKey=<the_public_key> --set globalConnectionSecret.privateApiKey=<the_private_key> --set globalConnectionSecret.orgId=<the_org_id> mongodb/mongodb-atlas-operator
```

### Upgrading the Operator:

```
helm upgrade mongodb-atlas-operator mongodb/mongodb-atlas-operator
```