#!/bin/sh
green='\033[0;32m'
red='\033[0;31m'
NOCOLOR='\033[0m'

while true; do
  namespace=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
  svc_url=http://httpdtest.netpol-a.svc.cluster.local
  timeout -k 2 2 curl -o /dev/null ${svc_url} -- 1>/dev/null 2>/dev/null
  command_rc=$?
  
  if [ $command_rc -ne 0 ] ; then
    conn_status=Unreachable
  else
    conn_status="Reachable "
  fi

  if [  "${test_should_work}" == "" ] ; then
    color=${red}
  elif [ $conn_status == "Unreachable" -a "${test_should_work}" == "yes" ] ; then
    color=${red}
  elif [ $conn_status == "Reachable" -a "${test_should_work}" == "no" ] ; then
    color=${red}
  elif [ ${conn_status} == "Unreachable" -a "${test_should_work}" == "no" ] ; then
    color=${green}
  elif [ ${conn_status} == "Reachable" -a "${test_should_work}" == "yes" ] ; then
    color=${green}
  else
    color=${red}
  fi
  
  echo -e "${color}ns:${namespace} node:${node_affiliation} conn:${conn_status} url:${svc_url}${NOCOLOR}"
  sleep 10
done