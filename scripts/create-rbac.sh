#!/bin/bash

service=$1

usage () {
  local errorMessage=$1
  echo
  echo "---------------------------------------------------------------"
  echo "Error: $errorMessage"
  echo "---------------------------------------------------------------"
  echo "usage: ./provision_demo_user.sh <username>"
  echo "  e.g. ./provision_demo_user.sh batman"
  echo "---------------------------------------------------------------"
  exit 1
}

if [ -z "$service" ]
then
  usage "No username specified"
fi

if [[ ! $service =~ ^[-a-z]{3,30}$ ]]
then
  usage "Username ${service} invalid. Username can only be lower-case letters, 3-30 characters in length"
fi

echo "Creating namespace and RBAC config for ${service}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${service}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa-${service}
  namespace: ${service}
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: role-${service}
  namespace: ${service}
rules:
- apiGroups: ["", "extensions", "apps", "rbac.authorization.k8s.io", "apiextensions.k8s.io"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: rb-${service}
  namespace: ${service}
subjects:
- kind: ServiceAccount
  name: sa-${service}
  namespace: ${service}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: role-${service}
EOF

# Create the kubeconfig

scripts/create-kubeconfig.sh ${service} --namespace ${service}
