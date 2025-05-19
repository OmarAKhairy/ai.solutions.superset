import os

# Secret key setup
SECRET_KEY = os.environ.get('SECRET_KEY')

# SQLite database by default (can be overridden)
SQLALCHEMY_DATABASE_URI = os.environ.get(
    'SQLALCHEMY_DATABASE_URI', 
    'sqlite:////tmp/superset.db'
)

# Additional settings
FEATURE_FLAGS = {
    "ALERT_REPORTS": True
}

# Set low timeout for Cloud Run
SQLALCHEMY_ENGINE_OPTIONS = {
    "connect_args": {
        "connect_timeout": 10
    }
}

# Increase timeout for gunicorn workers
SUPERSET_WEBSERVER_TIMEOUT = 300

