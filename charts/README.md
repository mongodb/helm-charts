# Quick Start

Please note that Database and OpsManager include an operator as a dependency. There is no need to install is separately.

```helm repo add mongodb https://github.io/mongodb/helm-charts```
```helm dependency  update```

In order to install Ops Manager run this command

```helm upgrade opsmanager . -n opsmanager --create-namespace  -i```

In order to install MongoDB DataBase:

```helm upgrade mongodb . --set opsManager.configMap=opsmanager-configmap --set opsManager.secretRef=opsmanager-org-access-key  -n $MONGODB_NAMESPACE --create-namespace -i```

Where `opsmanager-configmap` and `opsmanager-org-access-key` contain OpsManager connection properties

Helper script could be found at ../helpers/MongoDB-deploy.sh It contains an example that automates MongoDB Deployment using mongocli

