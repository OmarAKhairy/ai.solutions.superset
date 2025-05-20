FROM apache/superset:latest

USER root
# Create a configuration file
RUN mkdir -p /app/superset
COPY superset_config.py /app/superset/superset_config.py

# Install PostgreSQL driver and other dependencies
RUN pip install --no-cache-dir psycopg2-binary && \
    pip install --no-cache-dir sqlalchemy-redshift

# Switch back to superset user
USER superset

# Environment variables
ENV SECRET_KEY=temporary_key_replaced_at_runtime
ENV SUPERSET_CONFIG_PATH=/app/superset/superset_config.py

# Pre-initialize the database
RUN superset db upgrade && \
    superset init && \
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname Admin \
        --email admin@example.com \
        --password admin || true

# Most important change - use PORT environment variable from Cloud Run
CMD gunicorn --bind 0.0.0.0:${PORT:-8088} --workers 2 --timeout 120 "superset.app:create_app()"
