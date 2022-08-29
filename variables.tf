variable "argocd_chart_version" {
  description = "ArgoCD chart version to install. If not specified, latest version is installed"
  type        = string
  default     = null
}

variable "argocd_timezone" {
  description = "ArgoCD timezone in TZ format, eg. `Europe/Berlin`"
  type        = string
  validation {
    condition     = can(regex("/", var.argocd_timezone))
    error_message = "Please provide the timezone in TZ format"
  }
  default = "Europe/Berlin"
}

variable "argocd_ingress_enabled" {
  description = "Whether to enable a Kubernetes Ingress resource for the ArgoCD server. Will be set to `false` if `argocd_openshift` set to `true`"
  type        = bool
  default     = false
}

variable "argocd_openshift" {
  description = "Whether ArgoCD is deployed on OpenShift. If set to `true`, OpenShift route will be created and repo server will run under a random UID instead of 0"
  type        = bool
  default     = false
}

variable "argocd_admin_password_length" {
  description = "Length of the randomly generated password for the ArgoCD admin user"
  type        = number
  default     = 12
}

variable "argocd_admin_password_special_characters" {
  description = "Special characters to use for the randomly generated password for the ArgoCD admin user"
  type        = string
  default     = "_%@!"
}

variable "argocd_namespace" {
  description = "Kubernetes/OpenShift namespace to install ArgoCD chart to"
  type        = string
  default     = "argocd"
}

variable "argocd_namespace_create" {
  description = "Whether to create the namespace where ArgoCD chart will be installed"
  type        = bool
  default     = true
}

variable "argocd_repository_url" {
  description = "Git repository URL to be added to ArgoCD"
  type        = string
  validation {
    condition     = var.argocd_repository_url != null ? substr(var.argocd_repository_url, 0, 8) == "https://" : true
    error_message = "Only https is supported for argocd_project_source_repo_url"
  }
  default = null
}

variable "argocd_repository_name" {
  description = "Name of the repository to be added to ArgoCD"
  type        = string
  default     = null
}

variable "argocd_repository_username" {
  description = "The Username of the User/Service account for the Git repository"
  type        = string
  sensitive   = true
  default     = null
}

variable "argocd_repository_password" {
  description = "Secret Access Token for the Git repository"
  type        = string
  sensitive   = true
  default     = null
}

variable "argocd_project_name" {
  description = "Name of the ArgoCD project to be created"
  type        = string
  default     = null
}

variable "argocd_application_name" {
  description = "Name of the ArgoCD application to be created"
  type        = string
  default     = null
}

variable "argocd_application_repo_branch" {
  description = "Git repository branch where the ArgoCD application manifests reside"
  type        = string
  default     = "main"
}

variable "argocd_application_repo_path" {
  description = "Path within the Git repository where the ArgoCD application manifests reside"
  type        = string
  default     = ""
}

variable "argocd_chart_value_files" {
  description = "A list of paths to ArgoCD Helm chart values files to be added to the ArgoCD installation"
  type        = list(string)
  default     = []
}

variable "argocd_chart_values" {
  description = <<-EOT
  A map of key/value to set ArgoCD chart values or override defaults.
  The key must be specified as the full path to the key, e.g: `configs.secret.bitbucketServerSecret`. 
  Please consult [ArgoCD Helm chart docs](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd).
  EOT
  type        = map(string)
  default     = {}
}
