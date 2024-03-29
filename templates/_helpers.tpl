{{/*
Expand the name of the chart.
*/}}
{{- define "sre-app.name" -}}
{{- default .Chart.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sre-app.service" -}}
{{- printf "%s-%s" .Chart.Name .Values.service.name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sre-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sre-app.labels" -}}
helm.sh/chart: {{ include "sre-app.chart" . }}
{{ include "sre-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sre-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sre-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

