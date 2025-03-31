kubectl port-forward --namespace test-ksp svc/my-psql-postgresql 5432:5432 &


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

# PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432


# # Check connectivity by running a simple query
# "SELECT 1;"

# # Check PostgreSQL version
# "SELECT version();"

# # Check if tables exist
# "\dt"

# # Check active connections
# "SELECT * FROM pg_stat_activity;"

# # Check database size
# "SELECT pg_size_pretty(pg_database_size('$DBNAME'));"

# # Check the last backup (if applicable)
# "SELECT * FROM pg_stat_archiver;"

# "SELECT * FROM pg_stat_replication;"
# SELECT NOW();