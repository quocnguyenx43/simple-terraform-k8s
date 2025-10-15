{{/*
Return the application name
*/}}
{{- define "prediction-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the fully qualified app name (release + chart)
*/}}
{{- define "prediction-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "prediction-app.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end -}}
