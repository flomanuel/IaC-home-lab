# Based on:

# - https://cert-manager.io/docs/installation/helm/

# - https://www.youtube.com/watch?v=vJweuU6Qrgo

# 1. Install via a Helm chart

```bash
# add GPG keyring
curl -LO https://cert-manager.io/public-keys/cert-manager-keyring-2021-09-20-1020CF3C033D4F35BAE1C19E1226061C665DF13E.gpg

helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --create-namespace \
  --namespace cert-manager \
  --version v1.21.2 \
  --verify \
  --keyring ./cert-manager-keyring-2021-09-20-1020CF3C033D4F35BAE1C19E1226061C665DF13E.gpg \
  --values k3s_setup/3_cert-manager/values.yml
```
# 2. Set up a cluster issuer: ACME

Install kubernetes files.

# 3. Issue a new certificate for an Ingress Route

See nginx exmaple deployent.
