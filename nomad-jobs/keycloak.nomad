job "keycloak" {
  type = "service"
  datacenters = [
    "toronto"]

  group "keycloak" {
    count = 1

    network {
      mode = "host"
      port "http"  { to = 8080 }
      port "https"  { to = 8443 }
    }

    volume "keycloak-vol" {
      type = "host"
      read_only = false
      source = "keycloak-vol"
    }

    task "keycloak" {
      driver = "docker"

      volume_mount {
        volume = "keycloak-vol"
        destination = "/opt/jboss/keycloak/standalone/data"
        read_only = false
      }

      config {
        image = "quay.io/keycloak/keycloak:15.1.1"
        ports = [
          "http",
          "https"
        ]
      }

      env {
        KEYCLOAK_USER = "admin"
        KEYCLOAK_PASSWORD = "admin"
      }

      resources {
        memory = 512
        cpu = 300
      }

      service {
        name = "keycloak"
        tags = [
          "auth"]

        check {
          type = "tcp"
          interval = "10s"
          timeout = "2s"
          port = "http"
        }
      }
    }
  }
}