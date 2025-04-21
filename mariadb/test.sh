#!/bin/bash

# Set the namespace where the MariaDB pod is running
NAMESPACE="test-ksp"

# Retrieve the name of the MariaDB pod
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=mariadb -o jsonpath="{.items[0].metadata.name}")

echo "Checking MariaDB process..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- pgrep mysqld > /dev/null
if [ $? -ne 0 ]; then
  echo "MariaDB process is not running."
  exit 1
fi
echo "MariaDB process is running."


echo "Checking MariaDB connectivity..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mariadb-admin ping -h localhost -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" > /dev/null
if [ $? -ne 0 ]; then
  echo "Unable to connect to MariaDB."
  exit 1
fi
echo "MariaDB is accepting connections."


echo "Checking InnoDB engine initialization..."
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SHOW ENGINE INNODB STATUS\G"
if [ $? -ne 0 ]; then
  echo "InnoDB engine is not initialized."
  exit 1
fi
echo "InnoDB engine is initialized."

echo "All checks passed. MariaDB pod is ready."



kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SHOW DATABASES;"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SELECT 1;"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SELECT VERSION();"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SHOW PROCESSLIST;"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- mysql -u root -p"$(cat $MARIADB_ROOT_PASSWORD_FILE)" -e "SHOW SESSION STATUS LIKE 'Ssl_cipher';"





