> **DEPRECATED:** The MongoDB Enterprise Kubernetes Operator is now deprecated in favor of a new replacement Operator available here [mongodb/mongodb-kubernetes](https://github.com/mongodb/mongodb-kubernetes) with [official documentation here](https://www.mongodb.com/docs/kubernetes-operator/current/). Existing versions of the Enterprise Kubernetes Operator remain supported until end of life dates listed here: [official support lifecycle](https://www.mongodb.com/docs/kubernetes-operator/current/reference/support-lifecycle/).
>
> For more information on this decision - what it means and entails - see the [announcement](https://github.com/mongodb/mongodb-kubernetes/releases/tag/v1.0.0) and our [public documentation](https://www.mongodb.com/docs/kubernetes/current/).

# MongoDB Helm Charts repository for Kubernetes

This repository contains Helm Charts for different MongoDB products.

## Supported Charts

The following Charts are supported by MongoDB.

| Charts                                            | Description                                                                                          |
|---------------------------------------------------|------------------------------------------------------------------------------------------------------|
| [mongodb-operator](charts/mongodb-kubernetes)     | MongoDB Controllers for Kubernetes Helm Chart                                                       |
| [enterprise-operator](charts/enterprise-operator) | (**DEPRECATED** - use `mongodb-operator` instead) MongoDB Enterprise Kubernetes Operator Helm Chart. |
| [enterprise-database](charts/enterprise-database) | MongoDB Enterprise Kubernetes Database Helm Chart.                                                   |
| [atlas-operator](charts/atlas-operator)           | MongoDB Atlas Operator Helm Chart.                                                                   |
| [atlas-deployment](charts/atlas-deployment)       | MongoDB Atlas Deployment Helm Chart. Create Mongo Database resources.                                |
| [atlas-operator-crds](charts/atlas-operator-crds) | MongoDB Atlas Custom Resource Definitions (CRDs) Helm Chart.                                         |

## Unsupported Charts

The following Helm Charts are not supported by MongoDB.

| Charts                                                    | Description                                                                                                        |
|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [community-operator](charts/community-operator)           | (**DEPRECATED** - use `mongodb-operator` instead) MongoDB Community Operator Helm Chart.                           |
| [community-operator-crds](charts/community-operator-crds) | (**DEPRECATED** - use `mongodb-operator` instead) MongoDB Community Custom Resource Definitions (CRDs) Helm Chart. |
| [sample-app](charts/sample-app)                           | A Sample Front/Back-end application backed by a MongoDB Database.                                                  |

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

## Contribute

Please file issues before filing PRs. For PRs to be accepted, contributors must sign our [CLA](https://www.mongodb.com/legal/contributor-agreement).

Reviewers, please ensure that the CLA has been signed by referring to [the contributors tool](https://contributors.corp.mongodb.com/) (internal link).

## License

These helm charts are available under the Apache 2 license. Please refer to the github repos of the software that the charts install for additional license information.

* [MongoDB Atlas Operator](https://github.com/mongodb/mongodb-atlas-kubernetes)
* [MongoDB Controllers for Kubernetes](https://github.com/mongodb/mongodb-kubernetes)
