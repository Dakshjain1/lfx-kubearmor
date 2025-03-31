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

max_attempts=12  # 12 attempts * 5 seconds sleep = 60 seconds timeout
sleep_interval=5
attempt=0

while [ $attempt -lt $max_attempts ]; do
  # Execute the kubectl command and filter pods that are not in the Ready state
  not_ready_pods=$($KUBECTL_CMD | awk -v field=$READY_FIELD '$field ~ /0/ {print $0}')
  
  if [ -z "$not_ready_pods" ]; then
    echo "All pods are in the Ready state."
    exit 0
  else
    echo "Attempt $((attempt+1))/$max_attempts: The following pods are not ready yet:"
    echo "$not_ready_pods"
    echo "Retrying in $sleep_interval seconds..."
    sleep $sleep_interval
    ((attempt++))
  fi
done

echo "Timeout reached after $((max_attempts * sleep_interval)) seconds."
echo "The following pods did not become ready:"
echo "$not_ready_pods"
exit 1
