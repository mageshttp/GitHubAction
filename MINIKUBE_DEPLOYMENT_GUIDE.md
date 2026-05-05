# Minikube Deployment Guide

This guide explains how to deploy the Python Flask application to a local Minikube Kubernetes cluster.

## Prerequisites

### Required Software
- **Minikube**: v1.26 or higher
  ```bash
  # Install Minikube (macOS with Homebrew)
  brew install minikube
  
  # Install Minikube (Linux)
  curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  ```

- **kubectl**: v1.24 or higher
  ```bash
  # Install kubectl (macOS)
  brew install kubectl
  
  # Install kubectl (Linux)
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  ```

- **Docker**: v20.10 or higher
  ```bash
  # For installation instructions, visit: https://docs.docker.com/get-docker/
  ```

### System Requirements
- Minimum 2 CPU cores available
- Minimum 2GB RAM available
- 5GB free disk space

## Deployment Methods

### Method 1: Using the Deployment Script (Recommended)

The easiest way to deploy to Minikube is using the provided deployment script:

```bash
# Make the script executable
chmod +x deploy-minikube.sh

# Run the deployment script
./deploy-minikube.sh
```

The script will:
1. Check if Minikube is running (start it if not)
2. Configure Docker to use Minikube's daemon
3. Build the Docker image
4. Create Kubernetes namespace
5. Deploy the application
6. Display the access URL

### Method 2: Manual Deployment

If you prefer manual control, follow these steps:

#### Step 1: Start Minikube
```bash
# Start Minikube with Docker driver
minikube start --driver=docker

# Verify Minikube is running
minikube status
```

#### Step 2: Configure Docker Environment
```bash
# Point Docker CLI to Minikube's Docker daemon
eval $(minikube docker-env)
```

#### Step 3: Build Docker Image
```bash
# Build the image in Minikube's Docker daemon
docker build -t python-app:latest .

# Verify the image was built
docker images | grep python-app
```

#### Step 4: Create Kubernetes Namespace (Optional)
```bash
kubectl apply -f k8s/namespace.yaml
```

#### Step 5: Deploy the Application
```bash
# Deploy the application and service
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Verify deployment status
kubectl get deployments
kubectl get pods
kubectl get services
```

#### Step 6: Wait for Deployment to Be Ready
```bash
# Wait for all replicas to be ready (max 5 minutes)
kubectl rollout status deployment/python-flask-app
```

#### Step 7: Access the Application
```bash
# Get the service URL
minikube service python-flask-app-service --url

# Or open it directly in your browser
minikube service python-flask-app-service
```

## Configuration Details

### Kubernetes Resources

#### Deployment (`k8s/deployment.yaml`)
- **Replicas**: 2 (for load balancing)
- **Image Pull Policy**: `Never` (uses local Minikube image)
- **Resource Limits**:
  - Memory Request: 64Mi, Limit: 256Mi
  - CPU Request: 100m, Limit: 500m
- **Health Checks**:
  - Liveness Probe: HTTP GET `/` every 10 seconds
  - Readiness Probe: HTTP GET `/` every 5 seconds

#### Service (`k8s/service.yaml`)
- **Type**: NodePort
- **Port**: 5000
- **NodePort**: 30500 (accessible via `http://minikube-ip:30500`)

### Docker Image
- **Base Image**: `python:3.11-slim`
- **Exposed Port**: 5000
- **Entry Command**: `python app.py`

## Common Operations

### View Application Logs
```bash
# View logs from all pods
kubectl logs -l app=python-flask-app

# View logs from a specific pod
kubectl logs <pod-name>

# Stream logs in real-time
kubectl logs -l app=python-flask-app -f
```

### Port Forwarding
```bash
# Forward local port 5000 to pod port 5000
kubectl port-forward svc/python-flask-app-service 5000:5000

# Access the app at http://localhost:5000
```

### Scale the Deployment
```bash
# Scale to 3 replicas
kubectl scale deployment python-flask-app --replicas=3

# View the deployment
kubectl get deployment python-flask-app
```

### Update the Application
```bash
# After making changes to app.py:

# 1. Build a new image
eval $(minikube docker-env)
docker build -t python-app:latest .

# 2. Restart the deployment (pods will pull the new image)
kubectl rollout restart deployment/python-flask-app

# 3. Watch the rollout
kubectl rollout status deployment/python-flask-app
```

### Delete the Deployment
```bash
# Delete all resources
kubectl delete -f k8s/

# Or delete specific resources
kubectl delete deployment python-flask-app
kubectl delete service python-flask-app-service
```

### Access Minikube Dashboard
```bash
# Open Kubernetes dashboard
minikube dashboard

# This opens a browser with the Minikube dashboard showing:
# - Deployments
# - Pods
# - Services
# - Logs
# - Resource usage
```

## Troubleshooting

### Minikube won't start
```bash
# Check system resources
docker system df

# Reset Minikube
minikube delete
minikube start --driver=docker --memory=2048 --cpus=2
```

### Image not found
```bash
# Verify you're using Minikube's Docker daemon
eval $(minikube docker-env)

# List images in Minikube
docker images

# Rebuild the image
docker build -t python-app:latest .
```

### Pods not starting
```bash
# Check pod status
kubectl describe pod <pod-name>

# View pod logs
kubectl logs <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

### Can't access the application
```bash
# Get the Minikube IP
minikube ip

# Get the NodePort
kubectl get service python-flask-app-service -o jsonpath='{.spec.ports[0].nodePort}'

# Access via: http://<minikube-ip>:<node-port>
# Or use: minikube service python-flask-app-service --url
```

### Permission denied error
```bash
# Add your user to Docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker

# Re-login or restart Docker daemon
```

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow (`.github/workflows/deploy-minikube.yml`) that:

1. Triggers on pushes to `main`/`develop` branches
2. Checks out the code
3. Starts a Minikube instance in GitHub Actions
4. Builds the Docker image
5. Deploys to Minikube
6. Tests the application
7. Displays logs and pod information

### Running the Workflow
The workflow runs automatically on push, or manually via GitHub Actions tab:
```
GitHub Actions → Deploy to Minikube → Run workflow
```

## Performance Tuning

### Increase Minikube Resources
```bash
# Stop Minikube
minikube stop

# Start with more resources
minikube start --driver=docker --cpus=4 --memory=4096
```

### Enable Metrics Server (for Horizontal Pod Autoscaling)
```bash
minikube addons enable metrics-server
```

### Enable Ingress Controller
```bash
minikube addons enable ingress
```

## Next Steps

1. **Monitor**: Use `kubectl top nodes` and `kubectl top pods` to monitor resources
2. **Scale**: Update replica count in `k8s/deployment.yaml`
3. **Update Image**: Modify `app.py`, rebuild image, and restart deployment
4. **Add Health Checks**: Already configured in the deployment manifest
5. **Setup CI/CD**: The GitHub Actions workflow handles automated deployment

## Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Flask Documentation](https://flask.palletsprojects.com/)
