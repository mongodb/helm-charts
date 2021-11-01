# MongoDB Sample App

This Chart contains a very simple application that you can use to test your
MongoDB Deployment. This application requires a MongoDB resource deployed
with one of our Operators.

Both [Atlas](../atlas-operator) and [Community](../community-operator) create
a `Secret` containing a series of attributes that a client application can
use to connect to MongoDB. If you haven't done it yet, make sure you deploy
a MongoDB resource with one of the operators and install this chart with:


``` bash
helm install mongodb-app mongodb/sample-app --set mongodb.connectionStringSecret=<secret-with-connection-string>
```

The `Secret` containing the Connection String is always called:

    <resource-name>-<database>-<user>
