# Kube NetworkPolicy test

This Creates 3 namespaces a,b,c.
a and b and external can reach namespace a service lb.
c cannot join

netpol-a/service-LB.yaml should be upgraded to match cluster network ip.

working log sample:

~~~
external node:none  conn:Reachable  url:20.31.48.9:443
ns:netpol-c node:other conn:Unreachable url:http://httpdtest.netpol-a.svc.cluster.local:443
ns:netpol-a node:same  conn:Reachable  url:http://httpdtest.netpol-a.svc.cluster.local:443
ns:netpol-b node:other conn:Reachable  url:http://httpdtest.netpol-a.svc.cluster.local:443
ns:netpol-a node:other conn:Reachable  url:http://httpdtest.netpol-a.svc.cluster.local:443
~~~