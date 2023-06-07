#!/bin/sh

subkiller() {
    pkill '^oc'
    pkill 'display_logs.sh'
}

trap subkiller SIGINT

#internal access
while read project pod ; do
    oc -n ${project} logs -f ${pod} &
done< <(oc get pod -A -l app.kubernetes.io/part-of=netpol-observer | awk '$2 ~ /observer.*/ {print $1,$2}')

#external access
(
    green='\033[0;32m'
    red='\033[0;31m'
    NOCOLOR='\033[0m'
    service_external_ip=$(oc -n netpol-a get svc httpdtest -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    svc_url=${service_external_ip}:443
    test_should_work="yes"
    while true ; do
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
      echo -e "${color}   external node:none  conn:${conn_status} url:${svc_url}${NOCOLOR}"
      sleep 1
    done
)&

sleep 5

wait
echo "terminating logs viewer"