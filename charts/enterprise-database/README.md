# MongoDB Enterprise Kubernetes Database Helm Chart

A Helm Chart for deploying Mongo Databases with the [MongoDB Enterprise
Kubernetes Operator](https://github.com/mongodb/mongodb-enterprise-kubernetes).

## Prerequisites

This Chart creates `MongoDB` Kubernetes resources. You will need to have the
[MongoDB Enterprise Kubernetes Operator](../enterprise-operator) installed before
deploying MongoDB resources with this Chart.

The installation of this Chart does not have prerequisites. However, in order to
create a Mongo Database in your Kubernetes cluster, you'll need a [Cloud
Manager](https://cloud.mongodb.com) account or an [Ops
Manager](https://www.mongodb.com/products/ops-manager) installation.

Please look at the documentation for the [MongoDB Enterprise Kubernetes
Operator](../enterprise-operator) about how to do this.

## Installing Enterprise Database Chart

You can install the MongoDB Enterprise Database Chart easily with:

``` shell
helm install <resource-name> mongodb/enterprise-database
```

This operation will create a new MongoDB database in the current Namespace. Make
sure that the Enterprise Operator can handle `MongoDB` resources in this
Namespace. To set the `mongodb` namespace, for example:

``` shell
helm install <resource-name> mongodb/enterprise-database --namespace mongodb [--create-namespace]
```

To install the Enterprise Operator in a namespace called `mongodb`; with the
optional `--create-namespace` Helm will create the Namespace if it does not exist.

## Configuring access to Cloud Manager

You need your Ops Manager or Cloud Manager stored in a `Secret`, please refer to
the [MongoDB Enterprise Kubernetes Operator](../enterprise-operator) docs about how
to create them. Additionally, a `ConfigMap` will need to be created pointing at your
Cloud Manager or Ops Manager installation.

## Deploying a Sample Replica Set

With the `Secret` and `ConfigMap` created you will be able to create a new
ReplicaSet with the following command:

```
helm install my-database mongodb/enterprise-database \
  --set manager.configMapRef=<project> \
  --set manager.credentials=<credentials>
```

In this case, you'll change `<projet>` to the name of the `ConfigMap` you just
created, and `<credentials>` to the `Secret` you also just created in the
previous step.
