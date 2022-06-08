# Set in this file your deployment variables
cspm-key-id     = "c97dcb6e-95b4-4eb6-91d0-744fbe1688a4"
cspm-key-secret = "xxx"

cspm-org-unit   = "team-A"

azure-onboard   = true
azure-op-mode   = "Read" # operation_mode - (Required) Dome9 operation mode for the Azure account ("Read" or "Manage")
azure-accounts  =  {
  "0" = ["cloudguard_api_0602","xxx","xxx","xxx","xxx"]
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
