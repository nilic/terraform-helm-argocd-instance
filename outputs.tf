output "admin_password" {
  description = "Autogenerated password for the ArgoCD admin user"
  value       = random_password.argocd_admin_password.result
}

output "release_status" {
  description = "Status of the deployed ArgoCD Helm chart"
  value       = helm_release.argocd.metadata
}
