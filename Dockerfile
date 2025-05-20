FROM apache/superset:latest

USER root

# Create a configuration file
RUN mkdir -p /app/superset
COPY superset_config.py /app/superset/superset_config.py

# Switch back to superset user
USER superset

# Environment variables (will be overridden by Cloud Run)
ENV SECRET_KEY=temporary_key_replaced_at_runtime
ENV SUPERSET_CONFIG_PATH=/app/superset/superset_config.py

# Pre-initialize the database with retries for better reliability
RUN pip install --upgrade pip && \
    pip install retry && \
    echo '#!/bin/bash\nfor i in {1..3}; do\n  echo "Attempt $i of 3"\n  superset db upgrade && superset init && break\ndone\nsuperset fab create-admin --username admin --firstname Admin --lastname Admin --email admin@example.com --password admin || true' > /tmp/init.sh && \
    chmod +x /tmp/init.sh && \
    /tmp/init.sh

# Start command
EXPOSE 8088
CMD ["gunicorn", "--bind", "0.0.0.0:8088", "--workers", "2", "--timeout", "120", "superset.app:create_app()"]
