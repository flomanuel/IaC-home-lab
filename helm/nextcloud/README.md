# Steps

Instal Nextcloud (todo: migrae to GitOps with e.g. Argo CD).

## 1. Add Helm repository

```bash
helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update
```

## 2. Install Helm Chart

Install K8s resources for Nexctcloud (see ../kubernetes/nextcloud).

## 3. Install Helm Chart

```bash
helm install my-release nextcloud/nextcloud \
    --create-namespace \
    --namespace nextcloud \
    --values ./values.yml \
    --values ./secret-values.yml \
    --values ./ingress-values.yml
```
