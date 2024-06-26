# tf-azurerm-module_collection-security_group

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module deployes network security group in Azure Cloud Platform.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.77.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nsg"></a> [nsg](#module\_nsg) | Azure/network-security-group/azurerm | 4.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required)Location (Azure Region) for the network security group. | `string` | n/a | yes |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | (Required)Network security group name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)Name of the resource group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional)The tags to associate with your network security group. | `map(string)` | `{}` | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | (Optional)Security rules for the network security group using this format name = [name, priority, direction, access, protocol, source\_port\_range, destination\_port\_range, source\_address\_prefix, destination\_address\_prefix, description] | `any` | `[]` | no |
| <a name="input_destination_address_prefix"></a> [destination\_address\_prefix](#input\_destination\_address\_prefix) | Destination address prefix to be applied to all predefined rules. list(string) only allowed one element (CIDR, `*`, source IP range or Tags). Example ["10.0.3.0/24"] or ["VirtualNetwork"] | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_destination_address_prefixes"></a> [destination\_address\_prefixes](#input\_destination\_address\_prefixes) | (Optional)Destination address prefix to be applied to all predefined rules. Example ["10.0.3.0/32","10.0.3.128/32"] | `list(string)` | `null` | no |
| <a name="input_predefined_rules"></a> [predefined\_rules](#input\_predefined\_rules) | (Optional)Predefined rules | `any` | `[]` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional)Standard set of predefined rules | `map(any)` | <pre>{<br>  "ActiveDirectory-AllowADDSWebServices": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9389",<br>    "AllowADDSWebServices"<br>  ],<br>  "ActiveDirectory-AllowADGCReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3268",<br>    "AllowADGCReplication"<br>  ],<br>  "ActiveDirectory-AllowADGCReplicationSSL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3269",<br>    "AllowADGCReplicationSSL"<br>  ],<br>  "ActiveDirectory-AllowADReplication": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "389",<br>    "AllowADReplication"<br>  ],<br>  "ActiveDirectory-AllowADReplicationSSL": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "636",<br>    "AllowADReplicationSSL"<br>  ],<br>  "ActiveDirectory-AllowADReplicationTrust": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "445",<br>    "AllowADReplicationTrust"<br>  ],<br>  "ActiveDirectory-AllowDFSGroupPolicy": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "138",<br>    "AllowDFSGroupPolicy"<br>  ],<br>  "ActiveDirectory-AllowDNS": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "53",<br>    "AllowDNS"<br>  ],<br>  "ActiveDirectory-AllowFileReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5722",<br>    "AllowFileReplication"<br>  ],<br>  "ActiveDirectory-AllowKerberosAuthentication": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "88",<br>    "AllowKerberosAuthentication"<br>  ],<br>  "ActiveDirectory-AllowNETBIOSAuthentication": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "137",<br>    "AllowNETBIOSAuthentication"<br>  ],<br>  "ActiveDirectory-AllowNETBIOSReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "139",<br>    "AllowNETBIOSReplication"<br>  ],<br>  "ActiveDirectory-AllowPasswordChangeKerberes": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "464",<br>    "AllowPasswordChangeKerberes"<br>  ],<br>  "ActiveDirectory-AllowRPCReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "135",<br>    "AllowRPCReplication"<br>  ],<br>  "ActiveDirectory-AllowSMTPReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "25",<br>    "AllowSMTPReplication"<br>  ],<br>  "ActiveDirectory-AllowWindowsTime": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "123",<br>    "AllowWindowsTime"<br>  ],<br>  "Cassandra": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9042",<br>    "Cassandra"<br>  ],<br>  "Cassandra-JMX": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "7199",<br>    "Cassandra-JMX"<br>  ],<br>  "Cassandra-Thrift": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9160",<br>    "Cassandra-Thrift"<br>  ],<br>  "CouchDB": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5984",<br>    "CouchDB"<br>  ],<br>  "CouchDB-HTTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "6984",<br>    "CouchDB-HTTPS"<br>  ],<br>  "DNS-TCP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "53",<br>    "DNS-TCP"<br>  ],<br>  "DNS-UDP": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "53",<br>    "DNS-UDP"<br>  ],<br>  "DynamicPorts": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "49152-65535",<br>    "DynamicPorts"<br>  ],<br>  "ElasticSearch": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9200-9300",<br>    "ElasticSearch"<br>  ],<br>  "FTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "21",<br>    "FTP"<br>  ],<br>  "HTTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "80",<br>    "HTTP"<br>  ],<br>  "HTTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "443",<br>    "HTTPS"<br>  ],<br>  "IMAP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "143",<br>    "IMAP"<br>  ],<br>  "IMAPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "993",<br>    "IMAPS"<br>  ],<br>  "Kestrel": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "22133",<br>    "Kestrel"<br>  ],<br>  "LDAP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "389",<br>    "LDAP"<br>  ],<br>  "MSSQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "1433",<br>    "MSSQL"<br>  ],<br>  "Memcached": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "11211",<br>    "Memcached"<br>  ],<br>  "MongoDB": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "27017",<br>    "MongoDB"<br>  ],<br>  "MySQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3306",<br>    "MySQL"<br>  ],<br>  "Neo4J": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "7474",<br>    "Neo4J"<br>  ],<br>  "POP3": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "110",<br>    "POP3"<br>  ],<br>  "POP3S": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "995",<br>    "POP3S"<br>  ],<br>  "PostgreSQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5432",<br>    "PostgreSQL"<br>  ],<br>  "RDP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3389",<br>    "RDP"<br>  ],<br>  "RabbitMQ": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5672",<br>    "RabbitMQ"<br>  ],<br>  "Redis": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "6379",<br>    "Redis"<br>  ],<br>  "Riak": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "8093",<br>    "Riak"<br>  ],<br>  "Riak-JMX": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "8985",<br>    "Riak-JMX"<br>  ],<br>  "SMTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "25",<br>    "SMTP"<br>  ],<br>  "SMTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "465",<br>    "SMTPS"<br>  ],<br>  "SSH": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "22",<br>    "SSH"<br>  ],<br>  "WinRM": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5986",<br>    "WinRM"<br>  ]<br>}</pre> | no |
| <a name="input_source_address_prefix"></a> [source\_address\_prefix](#input\_source\_address\_prefix) | (Optional)Source address prefix to be applied to all predefined rules. list(string) only allowed one element (CIDR, `*`, source IP range or Tags). Example ["10.0.3.0/24"] or ["VirtualNetwork"] | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_source_address_prefixes"></a> [source\_address\_prefixes](#input\_source\_address\_prefixes) | (Optional)Source address prefix to be applied to all predefined rules. Example ["10.0.3.0/32","10.0.3.128/32"] | `list(string)` | `null` | no |
| <a name="input_use_for_each"></a> [use\_for\_each](#input\_use\_for\_each) | (Optional)Choose wheter to use 'for\_each' as iteration technic to generate the rules, defaults to false so we will use 'count' for compatibilty with previous module versions, but prefered method is 'for\_each' | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | The id of newly created network security group |
| <a name="output_network_security_group_name"></a> [network\_security\_group\_name](#output\_network\_security\_group\_name) | The name of newly created network security group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
