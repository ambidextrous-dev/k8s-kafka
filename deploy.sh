namespace=kafka
environment=$1

echo "Deploying to environment - $environment"

# switch to correct cluster
export KUBECONFIG=:/opt/kubecfg/$environment-kubecfg
kubectl config use-context $environment

# create namespace if not present
kubectl create namespace $namespace --dry-run -o yaml | kubectl apply -f -

# add bitnami repo
helm3 repo add bitnami https://charts.bitnami.com/bitnami

# Create Persistent Volumes for Kafka and Zookeeper
kubectl apply -f  k8s-manifests/$environment/kafka_pv.yaml --namespace $namespace
kubectl apply -f  k8s-manifests/$environment/zookeeper_pv.yaml --namespace $namespace

# Create Ingress
# kubectl apply -f  k8s-manifests/$environment/ingress.yaml --namespace $namespace

# Create configmap for kafka logs 
kubectl create configmap kafka-log4j-config -n $namespace \
    --from-file=./config/log4j.properties \
    --dry-run -o yaml | kubectl apply -f -

# Deploy Kafka and Zookeeper
helm3 upgrade --install kafka -f helm/kafka/values-$environment.yaml -n $namespace bitnami/kafka

# Deploy Schema Registry
kubectl apply -f k8s-manifests/$environment/schema-registry/service.yaml --namespace $namespace
kubectl apply -f k8s-manifests/$environment/schema-registry/deployment.yaml --namespace $namespace

# Deploy Kafka Connect
kubectl apply -f k8s-manifests/$environment/kafka-connect/pv.yaml --namespace $namespace
kubectl apply -f k8s-manifests/$environment/kafka-connect/service.yaml --namespace $namespace
kubectl apply -f k8s-manifests/$environment/kafka-connect/deployment.yaml --namespace $namespace