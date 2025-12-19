# FROM python:3.10-slim

# # Security best practice
# RUN useradd -m appuser

# WORKDIR /app

# COPY app/requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# COPY app/ .

# USER appuser

# EXPOSE 8000

# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
FROM python:3.10-slim

# Prevent Python from writing pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create non-root user (security best practice)
RUN useradd -m appuser

WORKDIR /app

# Install dependencies first (better layer caching)
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8000

# Run FastAPI via uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
