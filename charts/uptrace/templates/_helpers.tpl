{{/*
Expand the name of the chart.
*/}}
{{- define "uptrace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "uptrace.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "uptrace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "uptrace.labels" -}}
helm.sh/chart: {{ include "uptrace.chart" . }}
{{ include "uptrace.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "uptrace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "uptrace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "uptrace.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "uptrace.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "uptrace.config" -}}
{{- $config := omit .Values.uptrace.config "projects"}}
{{- $projects := list -}}
{{- $projects = append $projects .Values.uptrace.config.projects.default_project }}
{{- range $project := .Values.uptrace.config.projects.additional_projects }}
{{- $projects = append $projects $project }}
{{- end }}
{{- $config = merge $config (dict "projects" $projects) }}
{{- tpl (toYaml $config) . -}}
{{- end}}