provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "argocd" {
  source = "../.."

  argocd_ingress_enabled                   = true
  argocd_ingress_host                      = "argocd.example.com"
  argocd_admin_password_length             = 16
  argocd_admin_password_special_characters = "!_"
  argocd_project_name                      = "my-project"
  argocd_repository_name                   = "gitlab-argo"
  argocd_repository_url                    = "https://gitlab.com/foo/argo.git"
  argocd_repository_username               = "foo"
  argocd_repository_password               = "bar123"
  argocd_application_name                  = "root-app"
  argocd_application_repo_branch           = "dev"
  argocd_application_repo_path             = "argocd/manifests"
}
