
## MongoDB Helm Charts repositry for Kubernetes

This functionality is in alpha and is subject to change. The code is provided as-is with no warranties. Alpha features are not subject to the support SLA of official GA features.

# Quick Start

```helm repo add mongodb https://github.com/mongodb/helm-charts```
```helm dependency  update```

In order to install Ops Manager run this command

```helm upgrade opsmanager . -n opsmanager --create-namespace  -i```

In order to install MongoDB DataBase:

```helm upgrade mongodb . --set opsManager.configMap=opsmanager-configmap --set opsManager.secretRef=opsmanager-org-access-key  -n $MONGODB_NAMESPACE --create-namespace -i```

Where `opsmanager-configmap` and `opsmanager-org-access-key` contain OpsManager connection properties

Helper script could be found at ./helpers/MongoDB-deploy.sh It contains an example that automates MongoDB Deployment using mongocli


## Charts

This repository contains sample HELM charts for different MongoDB products

| charts                  |
|-------------------------|
| ent-operator            | 
| ent-operator-database   |
| ent-operator-opsmanager |
