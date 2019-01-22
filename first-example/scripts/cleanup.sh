kubectl delete services,deployments,pods --all -n cicd
kubectl delete namespace cicd
kubectl delete services,deployments,pods --all -n dev
kubectl delete namespace dev
kubectl delete services,deployments,pods --all -n staging
kubectl delete namespace staging
kubectl delete services,deployments,pods --all -n production
kubectl delete namespace production
kubectl delete services,deployments,pods --all -n dynatrace
kubectl delete namespace dynatrace
kubectl delete services,deployments,pods --all -n tower
kubectl delete namespace tower

# need to verify
kubectl delete clusterrolebindings.rbac.authorization.k8s.io dynatrace-cluster-admin-binding
kubectl delete clusterrolebindings.rbac.authorization.k8s.io jenkins-rbac
kubectl delete -f https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/kubernetes.yaml
kubectl delete -f ../manifests/istio/istio-gateway.yml