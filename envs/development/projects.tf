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


module "project" {

  source   = "../../modules/project-template"

  project_name = "project-name"

  billing_account   = local.billing_account
  folder            = google_assured_workloads_workload.folder_db_pb.resources[0].resource_id
#   folder            = local.parent_folder_name
  project_prefix    = local.project_prefix

  regions = local.regions

#   # firewall_endpoint_1 = var.firewall_endpoint_1
#   # firewall_endpoint_2 = var.firewall_endpoint_2


}
