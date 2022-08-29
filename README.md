# Terraform module for ArgoCD deploy and bootstrap

This module allows for deploying an ArgoCD instance on Kubernetes and OpenShift via the [official ArgoCD Helm chart](https://github.com/argoproj/argo-helm).

Optionally, Argo repository, project and application resources can be added by the module after deployment. This allows for ArgoCD bootstrap according to the [app of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/).

This module version supports ArgoCD charts up to (and not including) 5.0.0.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_password.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_admin_password_length"></a> [argocd\_admin\_password\_length](#input\_argocd\_admin\_password\_length) | Length of the randomly generated password for the ArgoCD admin user | `number` | `12` | no |
| <a name="input_argocd_admin_password_special_characters"></a> [argocd\_admin\_password\_special\_characters](#input\_argocd\_admin\_password\_special\_characters) | Special characters to use for the randomly generated password for the ArgoCD admin user | `string` | `"_%@!"` | no |
| <a name="input_argocd_application_name"></a> [argocd\_application\_name](#input\_argocd\_application\_name) | Name of the ArgoCD application to be created | `string` | `null` | no |
| <a name="input_argocd_application_repo_branch"></a> [argocd\_application\_repo\_branch](#input\_argocd\_application\_repo\_branch) | Git repository branch where the ArgoCD application manifests reside | `string` | `"main"` | no |
| <a name="input_argocd_application_repo_path"></a> [argocd\_application\_repo\_path](#input\_argocd\_application\_repo\_path) | Path within the Git repository where the ArgoCD application manifests reside | `string` | `""` | no |
| <a name="input_argocd_chart_value_files"></a> [argocd\_chart\_value\_files](#input\_argocd\_chart\_value\_files) | A list of paths to ArgoCD Helm chart values files to be added to the ArgoCD installation | `list(string)` | `[]` | no |
| <a name="input_argocd_chart_values"></a> [argocd\_chart\_values](#input\_argocd\_chart\_values) | A map of key/value to set ArgoCD chart values or override defaults.<br>The key must be specified as the full path to the key, e.g: `configs.secret.bitbucketServerSecret`. <br>Please consult [ArgoCD Helm chart docs](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd). | `map(string)` | `{}` | no |
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | ArgoCD chart version to install. If not specified, latest supported version is installed | `string` | `"4.10.9"` | no |
| <a name="input_argocd_ingress_enabled"></a> [argocd\_ingress\_enabled](#input\_argocd\_ingress\_enabled) | Whether to enable a Kubernetes Ingress resource for the ArgoCD server. Will be set to `false` if `argocd_openshift` set to `true` | `bool` | `false` | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | Kubernetes/OpenShift namespace to install ArgoCD chart to | `string` | `"argocd"` | no |
| <a name="input_argocd_namespace_create"></a> [argocd\_namespace\_create](#input\_argocd\_namespace\_create) | Whether to create the namespace where ArgoCD chart will be installed | `bool` | `true` | no |
| <a name="input_argocd_openshift"></a> [argocd\_openshift](#input\_argocd\_openshift) | Whether ArgoCD is deployed on OpenShift. If set to `true`, OpenShift route will be created and repo server will run under a random UID instead of 0 | `bool` | `false` | no |
| <a name="input_argocd_project_name"></a> [argocd\_project\_name](#input\_argocd\_project\_name) | Name of the ArgoCD project to be created | `string` | `null` | no |
| <a name="input_argocd_repository_name"></a> [argocd\_repository\_name](#input\_argocd\_repository\_name) | Name of the repository to be added to ArgoCD | `string` | `null` | no |
| <a name="input_argocd_repository_password"></a> [argocd\_repository\_password](#input\_argocd\_repository\_password) | Secret Access Token for the Git repository | `string` | `null` | no |
| <a name="input_argocd_repository_url"></a> [argocd\_repository\_url](#input\_argocd\_repository\_url) | Git repository URL to be added to ArgoCD | `string` | `null` | no |
| <a name="input_argocd_repository_username"></a> [argocd\_repository\_username](#input\_argocd\_repository\_username) | The Username of the User/Service account for the Git repository | `string` | `null` | no |
| <a name="input_argocd_timezone"></a> [argocd\_timezone](#input\_argocd\_timezone) | ArgoCD timezone in TZ format, eg. `Europe/Berlin` | `string` | `"Europe/Berlin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | Autogenerated password for the ArgoCD admin user.<br>This output is marked as sensitive by Terraform and therefore is displayed masked in the console output.<br>For information on how to display it unmasked take a look at [this article](https://support.hashicorp.com/hc/en-us/articles/5175257151891-How-to-output-sensitive-data-with-Terraform). |
| <a name="output_release_status"></a> [release\_status](#output\_release\_status) | Status of the deployed ArgoCD Helm chart |
