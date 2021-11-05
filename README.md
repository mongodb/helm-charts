# MongoDB Helm Charts repository for Kubernetes

## Trial Version of Helm Charts

This repository contains Helm Charts for different MongoDB products.

| Charts                                            | Description                                                               |
| ------------------------------------------------- | ------------------------------------------------------------------------- |
| [enterprise-operator](charts/enterprise-operator) | MongoDB Enterprise Kubernetes Operator Helm Chart.                        |
| [atlas-operator](charts/atlas-operator)           | MongoDB Atlas Operator Helm Chart.                                        |
| [atlas-cluster](charts/atlas-cluster)             | MongoDB Atlas Cluster Helm Chart. Create Mongo Database resources.        |
| [atlas-operator-crds](charts/atlas-operator-crds) | MongoDB Atlas Custom Resource Definitions (CRDs) Helm Chart.              |
| [community-operator](charts/community-operator)   | MongoDB Community Operator Helm Chart.                                    |
| [community-operator-crds](charts/community-operator-crds) | MongoDB Community Custom Resource Definitions (CRDs) Helm Chart.  |
| [sample-app](charts/sample-app)                   | A Sample Front/Back-end application backed by a MongoDB Database.         |

- Please note that the `CRD` Charts ([Community](charts/community-operator-crds)
  and [Atlas](charts/atlas-operator-crds)) will be installed, by default,
  as a dependency by the corresponding [Community](charts/community-operator)
  and [Atlas](charts/atlas-operator) Charts.

## Adding the MongoDB Helm Repo

The MongoDB Helm repository can be added using the `helm repo add` command, like
in the following example:

```
$ helm repo add mongodb https://mongodb.github.io/helm-charts
"mongodb" has been added to your repositories
```

## Additional Charts

All of MongoDB Helm charts will be moved into this repository. In the meantime,
please find them on their own repositories:

- [MongoDB Enterprise Kubernetes Operator](https://github.com/mongodb/mongodb-enterprise-kubernetes)
