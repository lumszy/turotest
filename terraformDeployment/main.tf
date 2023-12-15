terraform {
  required_version = "> 1.5"

  backend "local" {
    path = "~/Documents/turo/terraform.tfstate"
  }

}

#-----------------------------------------
# Default provider: Kubernetes
#-----------------------------------------

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "turo-interview"
  #config_context = "docker-desktop"
}
