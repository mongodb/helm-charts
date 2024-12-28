{{/*
Operator's watch namespaces
*/}}
{{- define "community-operator.watchNamespaces" -}}
  {{- $defaultNamespaces := list $.Release.Namespace }}
  {{- $namespaces := default $defaultNamespaces .Values.operator.watchNamespaces }}
  {{- if has "*" $namespaces }}
    {{- list "*" | toYaml }}
  {{- else }}
    {{- $namespaces | toYaml  }}
  {{- end }}
{{- end }}

{{/*
Database namespaces
*/}}
{{- define "community-operator.database.namespaces" -}}
  {{- $defaultNamespaces := include "community-operator.watchNamespaces" . | fromYamlArray }}
  {{- $namespaces := default $defaultNamespaces .Values.database.namespaces }}
  {{- if has "*" $namespaces }}
    {{- list | toYaml }}
  {{- else }}
    {{- $namespaces | toYaml }}
  {{- end }}
{{- end }}
