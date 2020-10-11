# Overview

This is a hobby project to run the Unifi Controller on Kubernetes for a home network.

# Getting started

Set up JSonnet:
```
$ pip3 install --user jsonnet
```

then continue with setting up Tanka [using the official documentation](https://tanka.dev/install).

# Applying configuration

Point your environment to a correct Kubernetes config file
```
$ export KUBECONFIG=~/.kube/microk8s.unify
```
and configure away
```
$ tk apply environments/default
```
