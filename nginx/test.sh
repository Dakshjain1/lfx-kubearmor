#!/bin/bash

# Set the namespace where the Nginx pod is running
NAMESPACE="test-ksp"

# Retrieve the name of the Nginx pod
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=nginx -o jsonpath="{.items[0].metadata.name}")

echo "Checking Nginx process..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -c nginx -- pgrep nginx > /dev/null
if [ $? -ne 0 ]; then
  echo "Nginx process is not running."
  exit 1
fi
echo "Nginx process is running."

echo "Validating Nginx configuration..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -c nginx -- nginx -t > /dev/null
if [ $? -ne 0 ]; then
  echo "Nginx configuration is invalid."
  exit 1
fi
echo "Nginx configuration is valid."

echo "Check nginx version"
NGINX_VERSION=$(kubectl exec -n "$NAMESPACE" "$POD_NAME" -c nginx -- nginx -v 2>&1)
if [ $? -ne 0 ]; then
  echo "Nginx version cmd failed."
  exit 1
fi
echo "$NGINX_VERSION."

echo "Testing nginx reload..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -c nginx -- nginx -s reload  > /dev/null
if [ $? -ne 0 ]; then
    echo "Reload command failed"
    exit 1
  else
    echo "NGINX reloaded successfully"
fi


echo "All checks passed. Nginx pod is ready."
