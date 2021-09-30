# MongoDB Helm Charts repository for Kubernetes

## Trial Version of Helm Charts

This repository contains Helm Charts for different MongoDB products. Currently,
only the MongoDB Atlas Operator is supported (in _Trial mode_).

| Charts                                                         | Description                                                                                                                      |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| [atlas-operator](charts/atlas-operator)                        | MongoDB Atlas Operator Helm Chart. _Start Here!_                                                                                 |
| [atlas-cluster](charts/atlas-cluster)                          | MongoDB Atlas Cluster Helm Chart. Create Mongo Database resources.                                                               |
| (_Optional_) [atlas-operator-crds](charts/atlas-operator-crds) | MongoDB Atlas Custom Resource Definitions (CRDs) Helm Chart. Installed automatically by [atlas-operator](charts/atlas-operator). |

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
- [MongoDB Community Operator](https://github.com/mongodb/mongodb-kubernetes-operator)
