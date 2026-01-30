#!/bin/sh

# Create cluster k3d
k3d cluster create gitops-local \
  --servers 1 \
  --agents 2 \
  --k3s-arg "--disable=traefik@server:0" \
  --port "8080:80@loadbalancer"
#$ kubectl get nodes

# Labels e taint
kubectl taint nodes k3d-gitops-local-server-0 \
  node-role.kubernetes.io/control-plane:NoSchedule

kubectl label node k3d-gitops-local-server-0 node-role=control-plane
kubectl label node k3d-gitops-local-agent-0 node-role=worker
kubectl label node k3d-gitops-local-agent-1 node-role=worker

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
