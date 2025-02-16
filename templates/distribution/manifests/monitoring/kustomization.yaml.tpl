# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/alertmanager-operated" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/blackbox-exporter" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/eks-sm" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/grafana" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/kube-proxy-metrics" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/kube-state-metrics" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/node-exporter" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/prometheus-adapter" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/prometheus-operated" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/prometheus-operator" }}
  - {{ print "../" .spec.distribution.common.relativeVendorPath "/modules/monitoring/katalog/x509-exporter" }} # FIXME
  - resources/ingress-infra.yml
  {{- if or .spec.distribution.modules.monitoring.alertmanager.deadManSwitchWebhookUrl .spec.distribution.modules.monitoring.alertmanager.slackWebhookUrl }}
  - secrets/alertmanager.yml
  {{- end }}

patchesStrategicMerge:
  - patches/alertmanager-operated.yml
  - patches/infra-nodes.yml
  - patches/prometheus-operated.yml
