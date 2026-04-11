<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_rest"></a> [rest](#requirement\_rest) | = 1.2.0 |

## Providers

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_rest"></a> [rest](#provider\_rest) | = 1.2.0 |

## Resources

## Resources

| Name | Type |
| ---- | ---- |
| [rest_resource.foundry_deployment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.available_models](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the parent Foundry account (Microsoft.CognitiveServices/accounts). | `string` | n/a | yes |
| <a name="input_capacity_settings_designated_capacity"></a> [capacity\_settings\_designated\_capacity](#input\_capacity\_settings\_designated\_capacity) | The designated (reserved) capacity for this deployment. Used in multi-deployment capacity management scenarios. | `number` | `null` | no |
| <a name="input_capacity_settings_priority"></a> [capacity\_settings\_priority](#input\_capacity\_settings\_priority) | The priority for capacity allocation when multiple deployments share capacity. Lower values = higher priority. | `number` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of this model deployment. Must be unique within the Foundry account. Used as the deployment endpoint identifier in API calls. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region of the parent Foundry account. Used to validate model availability at plan time. | `string` | n/a | yes |
| <a name="input_model_format"></a> [model\_format](#input\_model\_format) | The format/provider of the model. Determines which model catalog is used.<br/><br/>Common values:<br/>- "OpenAI"         — Azure OpenAI models (gpt-4o, gpt-4, text-embedding-ada-002, etc.)<br/>- "Meta"           — Meta Llama models (via Azure AI model catalog)<br/>- "Mistral"        — Mistral models<br/>- "Microsoft"      — Microsoft Phi models<br/>- "Cohere"         — Cohere models<br/><br/>The available formats depend on your region and subscription. | `string` | n/a | yes |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | The name of the model to deploy. Must match an available model in your region.<br/><br/>Common OpenAI models:<br/>- "gpt-4o"                — GPT-4o (recommended for most use cases)<br/>- "gpt-4o-mini"           — GPT-4o Mini (cost-optimised)<br/>- "gpt-4"                 — GPT-4<br/>- "gpt-35-turbo"          — GPT-3.5 Turbo<br/>- "text-embedding-ada-002" — Ada v2 embeddings<br/>- "text-embedding-3-small" — Ada 3 Small embeddings<br/>- "text-embedding-3-large" — Ada 3 Large embeddings<br/>- "dall-e-3"              — DALL-E 3 image generation<br/>- "whisper"               — Whisper speech-to-text<br/>- "tts"                   — Text-to-speech<br/>- "tts-hd"                — Text-to-speech HD<br/><br/>A plan-time precondition validates that the model is available in var.location. | `string` | n/a | yes |
| <a name="input_model_publisher"></a> [model\_publisher](#input\_model\_publisher) | The model publisher. Typically not needed for OpenAI models but required for some third-party catalog models. | `string` | `null` | no |
| <a name="input_model_source"></a> [model\_source](#input\_model\_source) | The model source URI. Used for fine-tuned or custom models deployed from a specific registry path. | `string` | `null` | no |
| <a name="input_model_source_account"></a> [model\_source\_account](#input\_model\_source\_account) | The source account resource ID for models being cross-account deployed. | `string` | `null` | no |
| <a name="input_model_version"></a> [model\_version](#input\_model\_version) | The specific model version to deploy (e.g. "2024-08-06" for gpt-4o).<br/>Leave null to use the current default version. Pin a version for<br/>reproducible behaviour — unpinned deployments may change on Microsoft's<br/>release schedule according to version\_upgrade\_option. | `string` | `null` | no |
| <a name="input_parent_deployment_name"></a> [parent\_deployment\_name](#input\_parent\_deployment\_name) | The name of the parent deployment. Used for hierarchical deployment configurations. | `string` | `null` | no |
| <a name="input_rai_policy_name"></a> [rai\_policy\_name](#input\_rai\_policy\_name) | The name of the Responsible AI (RAI) content filtering policy to apply to this deployment.<br/>Leave null to use the account default policy. Custom policies can be created in<br/>Azure AI Foundry Studio under Content Filters. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group containing the parent Foundry account. | `string` | n/a | yes |
| <a name="input_scale_capacity"></a> [scale\_capacity](#input\_scale\_capacity) | The capacity for scaleSettings. Typically set together with scale\_type. | `number` | `null` | no |
| <a name="input_scale_type"></a> [scale\_type](#input\_scale\_type) | The scale type for scaleSettings: 'Standard' or 'Manual'. Typically managed automatically — only set if instructed by Azure support. | `string` | `null` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | Capacity in thousands of tokens per minute (TPM) for Standard/GlobalStandard SKUs,<br/>or in Provisioned Throughput Units (PTU) for ProvisionedManaged SKUs.<br/><br/>Examples:<br/>- 10  → 10K TPM (Standard/GlobalStandard)<br/>- 100 → 100K TPM (GlobalStandard)<br/>- 300 → 300 PTU (ProvisionedManaged)<br/><br/>Leave null for some SKUs that manage capacity automatically (e.g. OnDemand). | `number` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The deployment SKU. Determines throughput, billing model, and availability.<br/><br/>- "Standard"                    — Pay-per-token, regional capacity<br/>- "GlobalStandard"              — Pay-per-token, global load-balanced capacity (recommended)<br/>- "DataZoneStandard"            — Pay-per-token, data-zone routing<br/>- "ProvisionedManaged"          — Reserved throughput (PTU) — requires quota approval<br/>- "DataZoneProvisionedManaged"  — Reserved throughput, data-zone routing<br/>- "OnDemand"                    — On-demand capacity (where available)<br/><br/>Use "GlobalStandard" for most production deployments unless data residency<br/>requirements mandate a regional or data-zone SKU. | `string` | n/a | yes |
| <a name="input_spillover_deployment_name"></a> [spillover\_deployment\_name](#input\_spillover\_deployment\_name) | The name of the fallback deployment to handle overflow traffic when this deployment reaches capacity. | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the deployment resource. | `map(string)` | `null` | no |
| <a name="input_version_upgrade_option"></a> [version\_upgrade\_option](#input\_version\_upgrade\_option) | Controls automatic version upgrades for the deployed model:<br/><br/>- "OnceNewDefaultVersionAvailable" (default): Automatically upgrades to the new<br/>  default version when Microsoft releases one. Minimal maintenance, but behaviour<br/>  may change.<br/>- "OnceCurrentVersionExpired": Stays on the pinned version until it reaches<br/>  end-of-life, then upgrades. Balance between stability and maintenance.<br/>- "NoAutoUpgrade": Never automatically upgrades. Requires manual version<br/>  management. Use when strict version pinning is required for compliance. | `string` | `"OnceNewDefaultVersionAvailable"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | The parent Foundry account name (plan-time, echoes input). |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this resource. |
| <a name="output_deployment_name"></a> [deployment\_name](#output\_deployment\_name) | The name of the deployment (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the deployment (plan-time). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region (plan-time, echoes input). |
| <a name="output_model_format"></a> [model\_format](#output\_model\_format) | The deployed model format (plan-time, echoes input). |
| <a name="output_model_name"></a> [model\_name](#output\_model\_name) | The deployed model name (plan-time, echoes input). |
| <a name="output_model_version_deployed"></a> [model\_version\_deployed](#output\_model\_version\_deployed) | The actual model version deployed (may differ from input if version was null — Azure selects the default). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the deployment (e.g. Succeeded). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (plan-time, echoes input). |
| <a name="output_sku_capacity_deployed"></a> [sku\_capacity\_deployed](#output\_sku\_capacity\_deployed) | The actual capacity allocated by Azure after apply. |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | The deployment SKU name (plan-time, echoes input). |
| <a name="output_version_upgrade_option"></a> [version\_upgrade\_option](#output\_version\_upgrade\_option) | The version upgrade option as confirmed by Azure after apply. |
<!-- END_TF_DOCS -->