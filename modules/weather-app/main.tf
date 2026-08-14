terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}

locals {
  labels = {
    "app"                        = var.app_name
    "app.kubernetes.io/name"     = var.app_name
    "app.kubernetes.io/instance" = "${var.app_name}-${var.environment}"
    "environment"                = var.environment
  }

  selector_labels = {
    "app" = var.app_name
  }

  redis_url = "rediss://:${var.redis_access_key}@${var.redis_host}:${var.redis_ssl_port}"

  namespace = var.create_namespace ? kubernetes_namespace.this[0].metadata[0].name : var.namespace
}

resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "kubernetes_secret" "app" {
  metadata {
    name      = "${var.app_name}-secrets"
    namespace = local.namespace
    labels    = local.labels
  }

  type = "Opaque"

  data = {
    WEATHER_API_KEY = var.weather_api_key
    REDIS_URL       = local.redis_url
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        labels = local.labels

        annotations = {
          "checksum/secret" = sha256(jsonencode(kubernetes_secret.app.data))
        }
      }

      spec {
        container {
          name              = var.app_name
          image             = "${var.image_repository}:${var.image_tag}"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = var.container_port
          }

          env {
            name  = "PORT"
            value = tostring(var.container_port)
          }

          env {
            name  = "NODE_ENV"
            value = "production"
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.app.metadata[0].name
            }
          }

          resources {
            requests = {
              cpu    = var.resource_requests.cpu
              memory = var.resource_requests.memory
            }
            limits = {
              cpu    = var.resource_limits.cpu
              memory = var.resource_limits.memory
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 30
            period_seconds        = 20
            failure_threshold     = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = var.app_name
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    type     = var.service_type
    selector = local.selector_labels

    port {
      name        = "http"
      port        = var.service_port
      target_port = "http"
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = var.service_type == "LoadBalancer"
}
