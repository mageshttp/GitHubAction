#!/bin/bash

# Minikube Python Flask App Deployment Script
# This script builds the Docker image and deploys it to Minikube

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Python Flask App - Minikube Deployment ===${NC}"

# Check if Minikube is running
echo -e "${BLUE}Checking Minikube status...${NC}"
if ! minikube status &>/dev/null; then
    echo -e "${RED}Minikube is not running. Starting Minikube...${NC}"
    minikube start --driver=docker
else
    echo -e "${GREEN}Minikube is running.${NC}"
fi

# Setup Docker environment to use Minikube's Docker daemon
echo -e "${BLUE}Setting up Minikube Docker environment...${NC}"
eval $(minikube docker-env)

# Build the Docker image using Minikube's Docker daemon
echo -e "${BLUE}Building Docker image...${NC}"
docker build -t python-app:latest .

# Create namespace
echo -e "${BLUE}Creating Kubernetes namespace...${NC}"
kubectl apply -f k8s/namespace.yaml

# Deploy to Minikube
echo -e "${BLUE}Deploying application to Minikube...${NC}"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment to be ready
echo -e "${BLUE}Waiting for deployment to be ready...${NC}"
kubectl rollout status deployment/python-flask-app -n python-app --timeout=300s

# Get service information
echo -e "${GREEN}=== Deployment Successful ===${NC}"
echo -e "${BLUE}Service Information:${NC}"
kubectl get service python-flask-app-service -n python-app

# Get Minikube service URL
echo -e "${BLUE}Getting service URL...${NC}"
SERVICE_URL=$(minikube service python-flask-app-service -n python-app --url)
echo -e "${GREEN}Application URL: ${SERVICE_URL}${NC}"

# Display pod information
echo -e "${BLUE}Pod Information:${NC}"
kubectl get pods -n python-app -l app=python-flask-app

# Display deployment information
echo -e "${BLUE}Deployment Information:${NC}"
kubectl get deployment python-flask-app -n python-app

echo -e "${GREEN}Deployment complete! Access the app at: ${SERVICE_URL}${NC}"
