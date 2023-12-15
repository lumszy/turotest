#-----------------------------------------
# KUBERNETES: Deploy ConfigMap
#-----------------------------------------

resource "kubernetes_manifest" "configmap" {

  manifest = yamldecode(file("../applicationDeployment/configMap.yml"))
  
}


#-----------------------------------------
# KUBERNETES: Deploy App
#-----------------------------------------

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(file("../applicationDeployment/deployment.yml"))
  
}

#-----------------------------------------
# KUBERNETES: svc 
#-----------------------------------------
resource "kubernetes_manifest" "service1" {
  manifest = yamldecode(file("../applicationDeployment/svc.yml"))
}

#-----------------------------------------
# KUBERNETES: ingress
#-----------------------------------------
resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("../applicationDeployment/ingress.yml"))
}