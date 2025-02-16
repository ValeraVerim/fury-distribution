# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

{{- define "dexHost" -}}
  {{ if .spec.distribution.modules.auth.overrides.ingresses.dex.host -}}
    {{ print "https://" .spec.distribution.modules.auth.overrides.ingresses.dex.host }}
  {{- else -}}
    {{ print "https://login." .spec.distribution.modules.auth.baseDomain }}
  {{- end }}
{{- end -}}
{{- define "pomeriumHost" }}
  {{- if .spec.distribution.modules.auth.overrides.ingresses.pomerium.host -}}
    {{ print "https://" .spec.distribution.modules.auth.overrides.ingresses.pomerium.host "/oauth2/callback" }}
  {{- else -}}
    {{ print "https://pomerium." .spec.distribution.modules.auth.baseDomain "/oauth2/callback" }}
  {{- end }}
{{- end -}}
{{ if eq .spec.distribution.modules.auth.provider.type "sso" }}
issuer: {{ template "dexHost" . }}
storage:
  type: kubernetes
  config:
    inCluster: true
web:
  http: 0.0.0.0:5556
telemetry:
  http: 0.0.0.0:5558
connectors:
{{ .spec.distribution.modules.auth.dex.connectors | toYaml | indent 2 }}
oauth2:
  skipApprovalScreen: true
staticClients:
- id: pomerium
  redirectURIs:
  - {{ template "pomeriumHost" . }}
  name: 'Pomerium in-cluster SSO'
  secret: {{ .spec.distribution.modules.auth.pomerium.secrets.IDP_CLIENT_SECRET }}
enablePasswordDB: false
{{ end }}
