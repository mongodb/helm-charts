# MongoDB Helm Charts repository for Kubernetes

This repository contains Helm Charts for different MongoDB products.

| Charts                                                                                                     | Description                                                        |
|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| [atlas-operator](https://github.com/mongodb/helm-charts/tree/main/charts/atlas-operator)                   | MongoDB Atlas Operator Helm Chart.                                 |
| [atlas-deployment](https://github.com/mongodb/helm-charts/tree/main/charts/atlas-deployment)               | MongoDB Atlas Deployment Helm Chart. Create Mongo Database resources. |
| [atlas-operator-crds](https://github.com/mongodb/helm-charts/tree/main/charts/atlas-operator-crds)         | MongoDB Atlas Custom Resource Definitions (CRDs) Helm Chart.       |
| [community-operator](https://github.com/mongodb/helm-charts/tree/main/charts/community-operator)           | MongoDB Community Operator Helm Chart.                             |
| [community-operator-crds](https://github.com/mongodb/helm-charts/tree/main/charts/community-operator-crds) | MongoDB Community Custom Resource Definitions (CRDs) Helm Chart.   |
| [enterprise-operator](https://github.com/mongodb/helm-charts/tree/main/charts/enterprise-operator)         | MongoDB Enterprise Kubernetes Operator Helm Chart.                 |
| [sample-app](https://github.com/mongodb/helm-charts/tree/main/charts/sample-app)                           | A Sample Front/Back-end application backed by a MongoDB Database.  |

- Please note that the `CRD` Charts ([Community](https://github.com/mongodb/helm-charts/tree/main/charts/community-operator-crds)
  and [Atlas](https://github.com/mongodb/helm-charts/tree/main/charts/atlas-operator-crds)) will be installed, by default,
  as a dependency by the corresponding [Community](https://github.com/mongodb/helm-charts/tree/main/charts/community-operator)
  and [Atlas](https://github.com/mongodb/helm-charts/tree/main/charts/atlas-operator) Charts.

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
