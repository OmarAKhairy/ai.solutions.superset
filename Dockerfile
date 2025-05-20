FROM apache/superset:latest

USER root

# Create config directory
RUN mkdir -p /app/pythonpath

# Create a configuration file that enables uploads
RUN echo 'import os\n\
SECRET_KEY = os.environ.get("SECRET_KEY", "insecure")\n\
FEATURE_FLAGS = {\n\
    "ALERT_REPORTS": True,\n\
    "ENABLE_JAVASCRIPT_CONTROLS": True,\n\
    "ENABLE_TEMPLATE_PROCESSING": True,\n\
    "DASHBOARD_NATIVE_FILTERS": True,\n\
    "VERSIONED_EXPORT": True,\n\
    "DYNAMIC_PLUGINS": True,\n\
    "ALLOW_FULL_CSV_EXPORT": True,\n\
    "DASHBOARD_CROSS_FILTERS": True,\n\
    "ENABLE_EXPLORE_DRAG_AND_DROP": True,\n\
    "EMBEDDED_SUPERSET": True,\n\
    "ALLOW_ADHOC_SUBQUERY": True,\n\
    "CSV_EXTENSIONS": ["csv", "tsv", "txt"],\n\
    "EXCEL_EXTENSIONS": ["xlsx", "xls"],\n\
    "ALLOWED_EXTENSIONS": ["csv", "xlsx", "xls"],\n\
    "ENABLE_REACT_CRUD_VIEWS": True,\n\
}\n\
# Enable file uploads\n\
UPLOAD_FOLDER = "/tmp/superset_uploads"\n\
UPLOAD_EXTENSION_ALLOWLIST = [".csv", ".xlsx", ".xls"]\n\
ALLOWED_EXTENSIONS = {"csv", "xlsx", "xls"}\n\
CSV_EXTENSIONS = {"csv", "tsv", "txt"}\n\
EXCEL_EXTENSIONS = {"xlsx", "xls"}' > /app/pythonpath/superset_config.py

# Create upload directory
RUN mkdir -p /tmp/superset_uploads && chmod 777 /tmp/superset_uploads

USER superset

# Set the PYTHONPATH to include our config
ENV PYTHONPATH=/app/pythonpath

# Start command
CMD gunicorn --bind 0.0.0.0:${PORT} --workers 2 --timeout 300 "superset.app:create_app()"
