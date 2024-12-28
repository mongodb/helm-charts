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
