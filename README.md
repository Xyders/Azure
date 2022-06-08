# 内容表示

1. ./dome9                       : CSPM onboarding (Azure tested)
2. ./high-availability-new-vnet  : CGNS HA on Azure デプロイ
3. ./hub and spoke hybrid network: ハブスポーク3VNET peeringデプロイ
4. ./modules                     : CGNSデプロイ用必要なモジュール
5. ./WIP                         : 作業中の一時フォルダー


# high-availability-new-vnetのデプロイ手順

1. Terraform環境導入：Terraform cloud (推奨、エンタプライズプランは不要) or セルフデプロイ
2. 必要な権限はサブスクリプションownerロール (az login or export 環境変数)
3. CGNSイメージに対する約款を承諾 (e.g. az vm image accept-terms --plan sg-byol --offer check-point-cg-r8110 --publish checkpoint)
4. `terraform.tfvars`　変数編集
5. `terraform init & plan & apply`


