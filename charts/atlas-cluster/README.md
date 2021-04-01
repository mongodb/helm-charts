# Helm Chart: MongoDB Atlas Operator (trial version)

The MongoDB Atlas Operator provides a native integration between the Kubernetes orchestration platform and MongoDB Atlas — the only multi-cloud document database service that gives you the versatility you need to build sophisticated and resilient applications that can adapt to changing customer demands and market trends.

## Quick start

**1.** Register for an Atlas account or log in

**2.** Create API Keys for your organization
    
    [Manage Programmatic Access to One Organization.] (https://docs.atlas.mongodb.com/configure-api-access)

**3.** Deploy Atlas Kubernetes Operator

``` 
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo update
helm install atlas-operator --namespace=atlas-operator --create-namespace mongodb/mongodb-atlas-operator
```

> Note. Operator will watch all available namespaces. In order to watch current namespace only set value `--set watchNamespaces=atlas-operator`
> operator could only watch all namespaces or just its own namespace. Currently watching other namespaces is not supported

**4.** Deploy MongoDB Atlas Cluster

```
helm install atlas-cluster \
--namespace=my-cluster \
--create-namespace mongodb/atlas-cluster \
--set project.atlasProjectName='My Project' \
--set atlas.orgId='<orgid>' \
--set atlas.publicApiKey='<publicKey>' \
--set atlas.privateApiKey='<privateApiKey>'
```

**5.** Connect to MongoDB Atlas Cluster

Default HELM Chart values will create single Atlas Admin user with name `atlas-cluster-admin-user`
Check the status of `AtlasDatabaseUser` resource for Ready state

```kubectl get atlasdatabaseusers atlas-cluster-admin-user -o=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'```

In order for Application to access connection string and password, Atlas Operator creates secret Object for each MongoDB User
```
kubectl get secret my-project-atlas-cluster-admin-user -n my-cluster
```

You could use this secret to mount to an application, for example:

```
containers:
 - name: test-app
   env:
     - name: "CONNECTION_STRING"
       valueFrom:
         secretKeyRef:
           name: my-project-atlas-cluster-admin-user
           key: connectionString.standardSrv
`` 


