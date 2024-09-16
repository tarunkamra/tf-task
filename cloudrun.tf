
provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

# [START cloudloadbalancing_ext_http_cloudrun]
module "lb-http" {
  source  = "terraform-google-modules/lb-http/google//modules/serverless_negs"
  version = "~> 10.0"

  name    = var.lb_name
  project = var.project_id

  ssl                             = var.ssl
  # managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = var.ssl
  labels                          = { "example-label" = "cloud-run-example" }

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn = false

      iap_config = {
        enable = false
      }
      log_config = {
        enable = false
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider              = google-beta
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.default.name
  }
}

resource "google_cloud_run_service" "default" {
  name     = "example"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        env {
          name = "INSTANCE_CONNECTION_NAME"
          value = google_sql_database_instance.instance.connection_name

        }
        env {
          name = "DB_USER"
          value = var.db_user
        }
        env {
          name = "DB_PASS"
          value = var.db_pass
        }
        env {
          name = "DB_NAME"
          value = var.db_name
        }
      }
    }
  }
  metadata {
    annotations = {
      # For valid annotation values and descriptions, see
      # https://cloud.google.com/sdk/gcloud/reference/run/deploy#--ingress
      "run.googleapis.com/ingress" = "all"
      
           
    }
  }
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# [END cloudloadbalancing_ext_http_cloudrun]

resource "google_sql_database_instance" "instance" {
  name             = "cloudrun-sql"
  region           = var.region
  database_version = "MYSQL_5_7"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "true"
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_pass
}