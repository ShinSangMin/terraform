MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -ex
B64_CLUSTER_CA=${ClusterCA}
API_SERVER_URL=${APIServerURL}
K8S_CLUSTER_DNS_IP=${ClusterDNS}
/etc/eks/bootstrap.sh ${ClusterName} --kubelet-extra-args '--container-log-max-size 100Mi --node-labels=eks.amazonaws.com/nodegroup-image=${CustomAMI},eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=${NodeGroup}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP 

--//--