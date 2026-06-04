# Use the official Ubuntu base image
FROM ubuntu:24.04

# Avoid prompts from apt during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install Apache
RUN apt-get update && apt-get install -y \
    apache2 \
    && rm -rf /var/lib/apt/lists/*

# Change Apache's default port from 80 to 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Overwrite the index.html page and set proper ownership
RUN echo "<!DOCTYPE html>
<html>
<head>
    <title>Cloud Run Deployment</title>
</head>
<body>
    <h1>CI/CD Pipeline Successful 🚀</h1>
    <p>Application deployed using Jenkins, Google Artifact Registry, and Cloud Run.</p>
    <p>Container image built, pushed to Artifact Registry, and automatically deployed to Cloud Run.</p>
</body>
</html>" > /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html

# Inform Docker that the container listens on port 8080 at runtime
EXPOSE 8080

# Start Apache in the foreground so the container stays running
CMD ["apachectl", "-D", "FOREGROUND"]
