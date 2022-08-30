/**
  * # Terraform module for ArgoCD deploy and bootstrap
  *
  * This module allows for deploying an ArgoCD instance on Kubernetes and OpenShift via the [official ArgoCD Helm chart](https://github.com/argoproj/argo-helm).
  *
  * Optionally, Argo repository, project and application resources can be added by the module after deployment. This allows for ArgoCD bootstrap according to the [app of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/).
  */

locals {
  additional_repository  = (var.argocd_repository_url != null && var.argocd_repository_name != null) ? true : false
  additional_project     = var.argocd_project_name != null ? true : false
  additional_application = (local.additional_repository && var.argocd_application_name != null) ? true : false

  server_settings = [templatefile(
    "${path.module}/templates/values-argocd-settings.tftpl",
    {
      admin_password = bcrypt(random_password.argocd_admin_password.result),
      timezone       = var.argocd_timezone
      ingress        = var.argocd_ingress_enabled ? "true" : "false"
      openshift      = var.argocd_openshift ? "true" : "false"
    }
  )]

  repository = local.additional_repository ? [templatefile(
    "${path.module}/templates/values-repository.tftpl",
    {
      url      = var.argocd_repository_url,
      name     = var.argocd_repository_name,
      username = var.argocd_repository_username != null ? var.argocd_repository_username : "''",
      password = var.argocd_repository_password != null ? var.argocd_repository_password : "''"
    }
  )] : []

  project = local.additional_project ? [templatefile(
    "${path.module}/templates/values-project.tftpl",
    {
      name      = var.argocd_project_name,
      namespace = var.argocd_namespace
    }
  )] : []

  application = local.additional_application ? [templatefile(
    "${path.module}/templates/values-application.tftpl",
    {
      name        = var.argocd_application_name,
      namespace   = var.argocd_namespace,
      project     = local.additional_project ? var.argocd_project_name : "default",
      repo_url    = var.argocd_repository_url,
      repo_branch = var.argocd_application_repo_branch,
      repo_path   = var.argocd_application_repo_path
    }
  )] : []
}

resource "random_password" "argocd_admin_password" {
  length           = var.argocd_admin_password_length
  special          = true
  override_special = var.argocd_admin_password_special_characters
}

resource "helm_release" "argocd" {
  name              = "argocd"
  chart             = "argo-cd"
  repository        = "https://argoproj.github.io/argo-helm"
  version           = var.argocd_chart_version
  namespace         = var.argocd_namespace
  create_namespace  = var.argocd_namespace_create
  timeout           = 600
  wait              = true
  wait_for_jobs     = true
  atomic            = true
  dependency_update = true

  values = concat(local.server_settings, local.repository, var.argocd_chart_value_files)

  dynamic "set" {
    for_each = var.argocd_chart_values

    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "argocd-apps" {
  count = (local.additional_project || local.additional_application) ? 1 : 0

  name              = "argocd-apps"
  chart             = "argocd-apps"
  repository        = "https://argoproj.github.io/argo-helm"
  version           = var.argocd_apps_chart_version
  namespace         = helm_release.argocd.namespace
  create_namespace  = false
  timeout           = 600
  wait              = true
  wait_for_jobs     = true
  atomic            = true
  dependency_update = true

  values = concat(local.project, local.application)
}
