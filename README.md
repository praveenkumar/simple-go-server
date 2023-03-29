This application is used for demo a simple usecase using CRC with microshift preset.

Run CRC with microshift preset
-----------------


```
$ crc config set preset microshift
$ crc start
$ crc status
CRC VM:          Running
RAM Usage:       1.182GB of 3.759GB
Disk Usage:      3.469GB of 8.579GB (Inside the CRC VM)
Cache Usage:     135GB
Cache Directory: /Users/prkumar/.crc/cache
```

Try the application locally using podman
----------------------------------------

This repo have `Containerfile` which can be used to generate the container image
for this application and we can directly use podman socket which is exposed by CRC

```
$ eval $(crc podman-env --root)
$ podman build -t quay.io/praveenkumar/myserver:v1 -f Containerfile .
$ podman run -d -p 8080:8080 quay.io/praveenkumar/myserver:v1
$ curl localhost:8080
hello
```

Now everything works locally and we also created the image, next step would be try
to deploy it on openshift cluster and see if our app still work.

```
$ eval $(crc oc-env)
$ export KUBECONFIG=${HOME}/.crc/machines/crc/kubeconfig
$ oc run myserver --image=quay.io/praveenkumar/myserver:v1 --port=8080 -l app=myserver
$ oc get pods
NAME       READY   STATUS    RESTARTS   AGE
myserver   1/1     Running   0          2s
$ oc create svc clusterip myserver --tcp=8080
$ oc get ep
NAME         ENDPOINTS            AGE
kubernetes   192.168.127.2:6443   3h1m
myserver     10.42.0.11:8080      3s
$ oc expose service myserver
$ oc get routes
NAME       HOST                                ADMITTED   SERVICE    TLS
myserver   myserver-default.apps.crc.testing   True       myserver   
$ curl myserver-default.apps.crc.testing
hello
```

Added the workflow to test the app
