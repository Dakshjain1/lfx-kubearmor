export POSTGRES_PASSWORD=$(kubectl get secret --namespace test-ksp my-psql-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
kubectl port-forward --namespace test-ksp svc/my-psql-postgresql 5432:5432 &
sleep 5
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432 <<EOF
SELECT 1;
SELECT version();
\dt
SELECT * FROM pg_stat_activity;
SELECT pg_size_pretty(pg_database_size('postgres'));
SELECT * FROM pg_stat_archiver;
SELECT * FROM pg_stat_replication;
SELECT NOW();
EOF
