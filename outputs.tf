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

output "network_security_group_id" {
  value       = module.nsg.network_security_group_id
  description = "The id of newly created network security group"
}

output "network_security_group_name" {
  value       = module.nsg.network_security_group_name
  description = "The name of newly created network security group"
}
