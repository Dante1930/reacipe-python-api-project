FROM python:3.13-slim
LABEL maintainer="fabfit24.com"

# Set working directory
WORKDIR /app

# Environment settings
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy files
COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Accept a build-time argument for dev mode
ARG DEV=false

# Set up venv, install packages, and add user
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp/requirements.txt /tmp/requirements.dev.txt && \
    adduser --disabled-password --no-create-home --uid 1000 appuser

# Add venv to PATH
ENV PATH="/py/bin:$PATH"

# Use non-root user
USER appuser

# Expose port
EXPOSE 8001

# Run server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]
