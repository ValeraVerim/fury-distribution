---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      containers:
        - name: aws-cluster-autoscaler
          env:
            - name: AWS_REGION
              value: {{ .spec.region }}
            - name: CLUSTER_NAME
              value: {{ .metadata.name }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: {{ template "iamRoleArn" (dict "package" "clusterAutoscaler" "spec" .spec) }}
  name: cluster-autoscaler
  namespace: kube-system
