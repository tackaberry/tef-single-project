/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {

  project_name = var.project_name

  vpc_name = "secure-vpc"

  project_id = "${var.project_prefix}-${local.project_name}"

  apis_to_enable = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "aiplatform.googleapis.com",
    "bigquery.googleapis.com",
    "alloydb.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "dataplex.googleapis.com",
    "run.googleapis.com",
    "cloudfunctions.googleapis.com",
    "container.googleapis.com",
    "secretmanager.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "cloudscheduler.googleapis.com",
  ]

}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "google_project" "main" {
  name                = local.project_name
  project_id          = "${local.project_name}-${random_string.suffix.result}"
  folder_id           = var.folder
  billing_account     = var.billing_account
  auto_create_network = false
}

resource "google_project_service" "apis" {
  for_each           = toset(local.apis_to_enable)
  project            = google_project.main.project_id
  service            = each.value
  disable_on_destroy = false
}
