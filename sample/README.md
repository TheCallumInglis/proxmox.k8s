# Proxmox K8s | Sample Deployment

Makes use of Istio Service Mesh to deploy a sample application on the Kubernetes cluster.

```bash
# Sample Usage
kubectl apply -f ./hello-world/

# Check Components
kubectl get pods,svc,gw,vs -n hello -o wide
```