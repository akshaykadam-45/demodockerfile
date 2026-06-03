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
RUN echo "hello From Unnati KuCL 2.4" > /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html

# Inform Docker that the container listens on port 8080 at runtime
EXPOSE 8080

# Start Apache in the foreground so the container stays running
CMD ["apachectl", "-D", "FOREGROUND"]
