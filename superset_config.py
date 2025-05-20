import os

# Secret key setup
SECRET_KEY = os.environ.get('SECRET_KEY', 'temporary_key_replaced_at_runtime')

# SQLite database by default (can be overridden)
SQLALCHEMY_DATABASE_URI = os.environ.get(
    'SQLALCHEMY_DATABASE_URI', 
    'sqlite:////tmp/superset.db'
)

# Additional settings
FEATURE_FLAGS = {
    "ALERT_REPORTS": True
}

# Increase timeout for gunicorn workers
SUPERSET_WEBSERVER_TIMEOUT = 300

# Remove the problematic engine options
# SQLALCHEMY_ENGINE_OPTIONS was causing the error
