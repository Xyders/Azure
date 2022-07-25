# Set in this file your deployment variables
# Infinity service account under shota org
cspm-key-id     = "dd837a66-****-****-****-************"
cspm-key-secret = "****bqhh8xt9eci3********"

cspm-org-unit   = "team A"

azure-onboard   = true
azure-op-mode   = "Manage" # operation_mode - (Required) Dome9 operation mode for the Azure account ("Read" or "Manage")
azure-accounts  =  {
  "0" = ["Scott Azure acct","bf9715e2-****-****-****-************","01605c2e-84df-4dfc-af6c-4f706350e670","afb4b565-7c87-431e-81df-4b083c263edd","ztS*************************************"]
# "1" = ["NAME","SUBSCRIPTION ID","TENANT ID","CLIENT ID","CLIENT PASSWORD"]
# "2" = ["NAME","SUBSCRIPTION ID","TENANT ID","CLIENT ID","CLIENT PASSWORD"]
}

aws-onboard   = false
aws-op-mode   = "ReadOnly" # new_group_behavior - (Required) The network security configuration. Select "ReadOnly", "FullManage", or "Reset".
aws-accounts  = {
  "0" = ["NAME","ARN","SECRET"]
# "1" = ["NAME","ARN","SECRET"]
# "2" = ["NAME","ARN","SECRET"]
}

k8s-onboard   = false
k8s-clusters  = {
  "0" = "K8s-Cluster-Name-1"
# "1" = "K8s-Cluster-Name-2"
# "2" = "K8s-Cluster-Name-3"
}