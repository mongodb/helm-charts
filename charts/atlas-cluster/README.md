# MongoDB Atlas Cluster Helm Chart

The MongoDB Atlas Operator provides a native integration between the Kubernetes
orchestration platform and MongoDB Atlas — the only multi-cloud document
database service that gives you the versatility you need to build sophisticated
and resilient applications that can adapt to changing customer demands and
market trends.

The Atlas Cluster Helm Chart knows how to manager Atlas resources bound to
Custom Resources in your Kubernetes Cluster. These resources are:

- Atlas Projects: An Atlas Project is a place to create your MongoDB clusters,
  think of it as a _Folder_ for your clusters.
- Atlas Clusters: A MongoDB Database hosted in Atlas. An Atlas Cluster lives
  inside an Atlas Project.
- Atlas Database User: An Atlas Database User is a User you can authenticate as
  and login into an Atlas Cluster.

By default the `atlas-cluster` Helm Chart will create a user to connect to the
newly deployed Atlas Cluster, avoiding having to do this from the Atlas UI.

## Prerequisites

In order to use this chart, the [Atlas Operator Helm Chart](../atlas-operator)
needs to be installed already.

## Usage

1. Register or login to [Atlas](https://cloud.mongodb.com).

2. Create API Keys for your organization. You can find more information in
   [here](https://docs.atlas.mongodb.com/configure-api-access). Make sure you
   write down your:

   - Public API Key: `publicApiKey`,
   - Private API Key: `privateApiKey` and
   - Organization ID: `orgId`.

3. Deploy MongoDB Atlas Cluster

In the following example you have to set the correct `<orgId>`, `publicKey` and `privateKey`.

```shell
helm install atlas-cluster mongodb/atlas-cluster\
    --namespace=my-cluster \
    --create-namespace  \
    --set project.atlasProjectName='My Project' \
    --set atlas.orgId='<orgid>' \
    --set atlas.publicApiKey='<publicKey>' \
    --set atlas.privateApiKey='<privateApiKey>'
```

## Connecting to MongoDB Atlas Cluster

The current state of your new Atlas cluster can be found in the
`status.conditions` array from the `AtlasCluster` resource:

```shell
kubectl get atlasdatabaseusers atlas-cluster-admin-user -o=jsonpath='{.status.conditions[?(@.type=="Ready")].status}'
```

Default HELM Chart values will create single Atlas Admin user with name
`atlas-cluster-admin-user`. Check the status of `AtlasDatabaseUser` resource for
Ready state.

You can test that the configuration is correct with the following command:

```shell
mongo $(kubectl -n my-cluster get secrets/my-project-atlas-cluster-admin-user -o jsonpath='{.data.connectionString\.standardSrv}' | base64 -d)
```

And Mongo Shell (`mongo`) should be able to connect and output something like:

```shell
MongoDB shell version v4.4.3
connecting to: mongodb://connection-string
Implicit session: session { "id" : UUID("xxx") }
MongoDB server version: 5.0.1
MongoDB Enterprise atlas-test-shard-0:PRIMARY> _
```

You have successfully connected to your Atlas instance!

## Example: Mounting Connection String to a Pod

You could use this secret to mount to an application, for example, the
_Connection String_ could be added as an environmental variable, that can be
easily consumed by your application.

```
containers:
 - name: test-app
   env:
     - name: "CONNECTION_STRING"
       valueFrom:
         secretKeyRef:
           name: my-project-atlas-cluster-admin-user
           key: connectionString.standardSrv
```

## Notes:

Atlas-operator version 0.6.1+ has to delete finalizers - this change requires additional steps.

Manually workaround for the update from Atlas-cluster-0.1.7:
1) need to remove manually the "helm.sh/hook" from Atlasproject

```bash
kubectl annotate atlasproject/opib6d6o6k helm.sh/hook-
```

2) need to add helm ownership annotation "meta.helm.sh/release-name" and "meta.helm.sh/release-namespace"

```bash
kubectl annotate atlasproject/opib6d6o6k meta.helm.sh/release-name=<release-name>
kubectl annotate atlasproject/opib6d6o6k meta.helm.sh/release-namespace=<namespace>
```

3) run update:

```bash
helm upgrade <release-name> mongodb/atlas-cluster <set variables>
```
