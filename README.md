# Addon Kyverno Policy Reporter

Upbound addon package for [Kyverno Policy Reporter](https://github.com/kyverno/policy-reporter).

Policy Reporter is a monitoring and observability tool for the [PolicyReport CRD](https://github.com/kubernetes-sigs/wg-policy-prototypes/blob/master/policy-report/README.md) standard. It watches PolicyReport and ClusterPolicyReport resources and provides Prometheus metrics, notification forwarding (Slack, Loki, Elasticsearch, etc.), and a REST API.

## Components

- **Policy Reporter (core)** — Watches PolicyReport CRDs, produces Prometheus metrics, forwards violations to notification targets
- **Kyverno Plugin** — Watches Kyverno policy CRDs, synthesizes PolicyReports from enforce-mode block events (enabled by default)

## Install

### As AddOn (UXP v2)

```yaml
apiVersion: pkg.upbound.io/v1beta1
kind: AddOn
metadata:
  name: policy-reporter
spec:
  package: xpkg.upbound.io/upbound/addon-kyverno-policy-reporter:3.7.4
```

### As Controller (Spaces)

```yaml
apiVersion: pkg.upbound.io/v1alpha1
kind: Controller
metadata:
  name: addon-kyverno-policy-reporter
spec:
  package: xpkg.upbound.io/upbound/addon-kyverno-policy-reporter:3.7.4
```

## Configuration

Override Helm values at install time using `AddOnRuntimeConfig`:

```yaml
apiVersion: pkg.upbound.io/v1beta1
kind: AddOnRuntimeConfig
metadata:
  name: policy-reporter-config
spec:
  helm:
    values:
      ui:
        enabled: true
      plugin:
        kyverno:
          blockReports:
            eventNamespace: ""
```

## Upstream

- Chart: `policy-reporter/policy-reporter` v3.7.4
- Source: https://github.com/kyverno/policy-reporter
- License: MIT
