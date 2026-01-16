# GKE Online Boutique Project - Command Guide

## 1. Project Setup (Section 1.1)
Use these commands to initialize  Google Cloud environment and create the Kubernetes cluster.

```bash
# List and set your project ID
gcloud projects list
gcloud config set project [PROJECT_ID]

# Set the compute zone
gcloud config set compute/zone europe-west6-a

# Create the standard GKE cluster
gcloud container clusters create base-lab-cluster
```

## 2. Local Load Testing (Section 1.3)
To run the load generator (Locust) from local machine against the cluster:

```bash
# Navigate to the loadgenerator directory
cd src/loadgenerator

# Build the Docker image
docker build -t load-server:latest .

# Run the container (Replace [FRONTEND_IP] with your service's External IP)
docker run --rm -e FRONTEND_ADDR="[FRONTEND_IP]" --name my-load-test load-server:latest
```

## 3. Canary Release with Istio (Section 2.3)
These commands cover resizing the cluster for Istio, installing the service mesh, and managing the traffic split.

### Cluster Preparation & Istio Install
```bash
# Resize cluster to 3 nodes to accommodate Istio resources
gcloud container clusters resize base-lab-cluster-final --zone us-central1-a --num-nodes=3

# Install Istio and enable sidecar injection
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
```

### Versioning & Traffic Splitting
```bash
# Label the existing frontend as version v1
kubectl label deployment frontend version=v1
kubectl patch deployment frontend -p '{"spec":{"template":{"metadata":{"labels":{"version":"v1"}}}}}'

```

### Verification & Monitoring
```bash
# Access the Kiali dashboard for visual verification
istioctl dashboard kiali


# Decommission the old version
kubectl delete deployment frontend
```

---
**Note:** Exact commands and run outputs in report
