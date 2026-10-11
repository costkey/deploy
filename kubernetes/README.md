# CostKey on Kubernetes

```bash
helm install costkey oci://ghcr.io/costkey/charts/costkey
kubectl port-forward svc/costkey 4100:80
```

Open http://localhost:4100 and sign up. The chart runs a small Postgres beside CostKey and generates secrets that survive upgrades.

With an ingress:

```bash
helm install costkey oci://ghcr.io/costkey/charts/costkey \
  --set ingress.enabled=true --set ingress.host=costkey.your-company.com --set ingress.className=nginx
```

With a managed database: `--set postgres.enabled=false --set externalDatabaseUrl=postgresql://...`.

`chart/` holds the same chart, to install from a checkout (`helm install costkey ./chart`) or fork. All settings are in [`chart/values.yaml`](chart/values.yaml).
