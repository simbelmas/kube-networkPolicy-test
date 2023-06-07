#!/bin/sh

cd "$(readlink -m $(dirname "$0"))"

oc apply -f namespaces.yaml
oc apply -f netpol-a-application.yaml
oc apply -f netpol-a-service.yaml
oc -n netpol-a apply -f observer.yaml
oc -n netpol-b apply -f observer.yaml
oc -n netpol-c apply -f observer.yaml