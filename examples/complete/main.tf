// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "nsg" {
  source = "../.."

  resource_group_name = module.resource_group.name

  security_group_name = local.network_security_group_name
  location            = var.region
  tags = {
    resource_name = local.network_security_group_name
  }

  custom_rules                 = var.custom_rules
  destination_address_prefix   = var.destination_address_prefix
  destination_address_prefixes = var.destination_address_prefixes
  predefined_rules             = var.predefined_rules
  rules                        = var.rules
  source_address_prefix        = var.source_address_prefix
  source_address_prefixes      = var.source_address_prefixes

  use_for_each = var.use_for_each

  depends_on = [module.resource_group]

}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group_name
  location = var.region
  tags = {
    resource_name = local.resource_group_name
  }

}

# This module generates the resource-name of resources based on resource_type, naming_prefix, env etc.
module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}
