terraform {
  required_version = "> 1.5"
}

#-----------------------------------------
# Default provider: Kubernetes
#-----------------------------------------

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "turo-interview"
  #config_context = "docker-desktop"
}
