#!/bin/sh

# Create cluster k3d
k3d cluster create gitops-local \
  --servers 1 \
  --agents 0 \
  --port "8080:80@loadbalancer"
#$ kubectl get nodes

# Instalar ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#$ kubectl get pods -n argocd
#$ kubectl port-forward svc/argocd-server -n argocd 8081:443
#$ kubectl get secret argocd-initial-admin-secret \
#$   -n argocd \
#$   -o jsonpath="{.data.password}" | base64 -d

# Bootstrap do ArgoCD (App of Apps)
kubectl apply -f argocd/bootstrap.yaml

#$ curl -H "Host: whoami.localhost" http://localhost:8080
#$ kubectl delete deployment whoami -n whoami
#$ kubectl delete ns whoami
