{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "django-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "django-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "django-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "django-chart.labels" -}}
helm.sh/chart: {{ include "django-chart.chart" . }}
{{ include "django-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "django-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "django-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ .Values.component }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "django-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "django-chart.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create custom imagePullSecret
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imagePullSecrets.registry (printf "%s:%s" .Values.imagePullSecrets.username .Values.imagePullSecrets.password | b64enc) | b64enc }}
{{- end }}

{{/*
Create imagePullSecret name
*/}}
{{- define "imagePullSecrets.name" }}
{{- if eq .Values.imagePullSecrets.create true }}
{{- include "django-chart.fullname" . }}-regcred
{{- else }}
{{- .Values.imagePullSecrets.name }}
{{- end }}
{{- end }}

{{/*
Create secretKeyRef name
*/}}
{{- define "secretKeyRef.name" }}
{{- if eq .Values.postgresql.credentials.create true }}
{{- include "django-chart.fullname" . }}-pgcred
{{- else }}
{{- .Values.postgresql.credentials.name }}
{{- end }}
{{- end }}