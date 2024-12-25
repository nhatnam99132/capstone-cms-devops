terraform init
gcloud auth application-default login
terraform plan -out tfplan

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

gcloud container clusters get-credentials devops-gke-cluster-02 --region asia-southeast1 --project woven-honor-443710-f5
al

helm install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress   --create-namespace   --set controller.service.type=LoadBalancer   --set controller.service.externalTrafficPolicy=Local

helm install grafana prometheus-community/kube-prometheus-stack   --namespace monitoring   --create-namespace   --set forceCreateNamespace=true   -f grafana.yml



helm install my-chart my-chart/ --namespace my-app   --create-namespace
kubectl get svc -n my-app

helm uninstall ingress-nginx -n ingress