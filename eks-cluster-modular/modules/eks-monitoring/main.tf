resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "57.0.2" # Ou la dernière version stable

  create_namespace = true

  values = [
    file("${path.module}/values-prometheus.yaml")
  ]
}