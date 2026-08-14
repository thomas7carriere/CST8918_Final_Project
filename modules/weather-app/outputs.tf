output "service_name" {
  description = "Name of the Kubernetes Service."
  value       = kubernetes_service.app.metadata[0].name
}

output "namespace" {
  description = "Namespace the app was deployed into."
  value       = local.namespace
}

output "deployed_image" {
  description = "Full image reference that was deployed."
  value       = "${var.image_repository}:${var.image_tag}"
}

output "load_balancer_ip" {
  description = "Public IP assigned by Azure. Empty unless service_type is LoadBalancer."
  value = try(
    kubernetes_service.app.status[0].load_balancer[0].ingress[0].ip,
    ""
  )
}

output "app_url" {
  description = "Browsable URL for the running app."
  value = try(
    "http://${kubernetes_service.app.status[0].load_balancer[0].ingress[0].ip}",
    ""
  )
}
