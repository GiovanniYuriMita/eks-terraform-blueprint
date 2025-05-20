resource "helm_release" "aws-node-termination-handler" {
  name             = "aws-node-termination-handler"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-node-termination-handler"
  version          = "0.21.0"
  namespace        = "kube-system"
  create_namespace = false

  values = [
    yamlencode({
      podSecurityPolicy = {
        enabled = false
      }
    })
  ]
}