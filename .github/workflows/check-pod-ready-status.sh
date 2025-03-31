#!/bin/bash

# Assign the namespace argument to a variable; leave empty if not provided
NAMESPACE=$1

# Determine the appropriate field for the READY column based on the presence of a namespace
if [ -z "$NAMESPACE" ]; then
  # No namespace specified; use '-A' to check all namespaces and set field to $3
  KUBECTL_CMD="kubectl get pods -A --no-headers"
  READY_FIELD=3
else
  # Namespace specified; set field to $2
  KUBECTL_CMD="kubectl get pods -n $NAMESPACE --no-headers"
  READY_FIELD=2
fi

echo "Waiting for all pods to reach the Ready state..."

while true; do
  # Execute the kubectl command and filter pods that are not in the Ready state
  not_ready_pods=$($KUBECTL_CMD | awk -v field=$READY_FIELD '$field ~ /0/ {print $0}')
  
  if [ -z "$not_ready_pods" ]; then
    echo "All pods are in the Ready state."
    break
  else
    echo "The following pods are not ready yet:"
    echo "$not_ready_pods"
    echo "Retrying in 5 seconds..."
    sleep 5
  fi
done
