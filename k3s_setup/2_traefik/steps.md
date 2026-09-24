# Based on
# - https://www.youtube.com/watch?v=vJweuU6Qrgo
# - https://doc.traefik.io/traefik/getting-started/kubernetes/#install-traefik

# 1. Install Traefik using Helm chart

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik -f traefik-values.yaml --wait
helm install traefik traefik/traefik -f /path/to/traefik-values.yml --wait --namespace traefik --create-namespace
```
Response from above Helm chart.
```bash
⚠️ DEPRECATION WARNING: Gateway API CRDs will no longer be shipped with this chart in a future major version.
You will need to install them yourself before deploying Traefik v3.7:
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.5.1/standard-install.yaml
```
