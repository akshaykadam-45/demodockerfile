FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8080

RUN apt-get update && apt-get install -y apache2 \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf \
    && sed -i "s/<VirtualHost \*:80>/<VirtualHost \*:${PORT}>/" /etc/apache2/sites-available/000-default.conf

RUN echo '<!DOCTYPE html>
<html>
<head>
<title>Cloud Run Deployment</title>
</head>
<body>
<h1>CI/CD Pipeline Successful 🚀</h1>
<p>Application deployed using Jenkins, Google Artifact Registry, and Cloud Run.</p>
</body>
</html>' > /var/www/html/index.html

EXPOSE 8080

CMD ["apachectl", "-D", "FOREGROUND"]
