{{- define "virtualservice.handleRetries" -}}
{{- if .Values.defaultRouting.retries.enabled }}
    retries:
{{- if .Values.defaultRouting.retries.settings }}
{{ .Values.defaultRouting.retries.settings | toYaml | trim | indent 6 }}
{{- else }}
      attempts: 3
      perTryTimeout: 2s
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "virtualservice.guardAgainstLeadingSlashInMatch" -}}
  {{- if hasPrefix "/" . }}
    {{ fail "url matches must not include leading slash"}}
  {{- end}}
{{- end -}}

{{- define "virtualservice.destination" -}}
- destination:
    host: {{ include "platform-service.serviceName" . | quote }}
{{- end }}

{{- define "virtualservice.route" -}}
route:
{{ include "virtualservice.destination" . }}
{{- if .Values.defaultRouting.corsPolicy }}
corsPolicy:
{{ .Values.defaultRouting.corsPolicy | toYaml | trim | indent 2 }}
{{- end }}
{{- end -}}

{{- define "virtualservice.urlExactMatches" -}}
{{- if .Values.defaultRouting.urlExactMatches }}
    match:
  {{- range .Values.defaultRouting.urlExactMatches }}
  {{- include "virtualservice.guardAgainstLeadingSlashInMatch" . }}
  {{- $slashMatch := printf "/%s" . }}
    - uri:
        exact: {{ $slashMatch }}
    - uri:
        prefix: {{ $slashMatch }}/
  {{- end }}
{{ include "virtualservice.route" .  | indent 4 }}
{{- end }}
{{- end -}}
