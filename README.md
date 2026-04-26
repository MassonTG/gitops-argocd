# Project 6 — GitOps with ArgoCD + Helm

Watchlist app deployed with full GitOps pipeline using ArgoCD and Helm.

## Stack
Terraform · k3s · Kubernetes · Helm · ArgoCD · Docker · GitHub Actions · AWS EC2

## Architecture
GitHub repo (gitops-argocd)
├── helm/watchlist/     ← Helm chart
├── argocd/             ← ArgoCD Application manifest
└── .github/workflows/  ← CI/CD pipeline
GitHub Actions (on push to docker/**)
1. Build Docker images
2. Push to Docker Hub with timestamp tag
3. Update image tag in values.yaml
4. Commit and push values.yaml
ArgoCD (watches GitHub repo)
→ detects change in values.yaml
→ automatically syncs cluster
→ deploys new version

## GitOps Flow
git push → GitHub Actions → new image tag → values.yaml update → ArgoCD sync → deploy

## Deploy

### 1. Infrastructure
```bash
cd terraform && terraform apply -auto-approve
```

### 2. Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Apply ArgoCD Application
```bash
kubectl apply -f argocd/application.yaml
```

### 4. Access
- App: http://<ip>:30080
- ArgoCD UI: https://<ip>:30088

## Cleanup
```bash
cd terraform && terraform destroy -auto-approve
```
