# Prometheus & Grafana on Kubernetes

## Setup Instructions

### 1. Create Monitoring Namespace

```bash
kubectl create namespace monitoring
```

---

## Prometheus Setup

### 2. Apply Cluster Role

```bash
kubectl apply -f clusterRole.yaml
```

### 3. Create Prometheus ConfigMap

```bash
kubectl create -f https://raw.githubusercontent.com/bibinwilson/kubernetes-prometheus/master/config-map.yaml
```

### 4. Deploy Prometheus

```bash
kubectl create -f prometheus-deployment.yaml
```

### 5. Access Prometheus Dashboard

```bash
kubectl port-forward <prometheus-deployment-name> 8080:9090 -n monitoring
```

Open your browser at:
http://localhost:8080

---

## Metrics Collectors

### Per-Node Metrics (Node Exporter)

```bash
kubectl create -f node-exporter-daemonset.yaml
kubectl create -f node-exporter-service.yaml
```

---

### Per-Pod Metrics (cAdvisor)

```bash
kubectl create -f cadvisor-daemonset.yaml
kubectl create -f cadvisor-service.yaml
```

---

### Kubernetes State Metrics

```bash
kubectl apply -f kube-state-metrics-configs/
```

---

## Grafana Setup

### 6. Create Grafana Datasource

```bash
kubectl create -f ./grafana-datasource-config.yaml
```

### 7. Deploy Grafana

```bash
kubectl create -f ./grafana-deployment.yaml
```

### 8. Create Grafana Service

```bash
kubectl create -f grafana-service.yaml
```

### 9. Access Grafana Dashboard

```bash
kubectl port-forward -n monitoring <grafana-pod-name> 3000:3000
```

Open your browser at:
http://localhost:3000

Default credentials (if not overridden):
- Username: admin
- Password: admin

---

## Grafana Dashboards

Import the following dashboard JSON files into Grafana:

- `per_node_dashboard.json` – Node-level metrics
- `per_pod_dashboard.json` – Pod and container-level metrics

---

## Cleanup

```bash
kubectl delete namespace monitoring
```

---