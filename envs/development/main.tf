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
    env                = "development"
    project_prefix     = var.project_prefix

    parent_folder_name = var.parent_folder
    region = "northamerica-northeast1"
    organization = var.org_id

    identity_domain      = data.google_organization.org.domain

    billing_account = var.billing_account

    regions = [
        "northamerica-northeast1",
        "northamerica-northeast2"
    ]

}

data "google_organization" "org" {
  organization = local.organization
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

provider "google-beta" {
  project               = google_project.seed_project.project_id
  billing_project       = google_project.seed_project.project_id
  user_project_override = true
}

resource "google_folder" "folder_pb" {
  display_name = "fldr-${local.project_prefix}-pb"
  parent       = "folders/${local.parent_folder_name}"
}

resource "google_folder" "folder_unclass" {
  display_name = "fldr-${local.project_prefix}-unclass"
  parent       = "folders/${local.parent_folder_name}"
}

resource "google_assured_workloads_workload" "folder_db_pb" {
  compliance_regime         = "DATA_BOUNDARY_FOR_CANADA_PROTECTED_B"
  display_name              = "fldr-${local.project_prefix}-pb-${random_string.suffix.result}"
  location                  = "ca"
  organization              = local.organization
  billing_account           = "billingAccounts/${local.billing_account}"
  enable_sovereign_controls = true

  provisioned_resources_parent = google_folder.folder_pb.name

  resource_settings {
    resource_type = "CONSUMER_FOLDER"
  }

  provider                  = google-beta

  depends_on = [google_project_service.activate_apis, google_folder.folder_pb] 

}