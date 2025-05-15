#!/bin/bash

# Exit on error
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y apt-transport-https ca-certificates curl software-properties-common nginx certbot python3-certbot-nginx

# Install Docker and Docker Compose
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create necessary directories
mkdir -p data/certbot/conf
mkdir -p data/certbot/www
mkdir -p logs
mkdir -p /root/backups

# Set up backup cron job
(crontab -l 2>/dev/null; echo "0 2 * * * /root/company-research/scraper_v2/backup.sh") | crontab -

# Make scripts executable
chmod +x backup.sh
chmod +x healthcheck.sh

# Copy Nginx configuration
cp nginx.conf /etc/nginx/nginx.conf

# Build and start Docker containers
docker compose up -d --build

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Check if services are running
if ! docker compose ps | grep -q "Up"; then
    echo "Error: Services failed to start"
    docker compose logs
    exit 1
fi

# Test Nginx configuration
nginx -t

# Restart Nginx
systemctl restart nginx

# Set up SSL with Let's Encrypt (uncomment and modify when ready)
# certbot --nginx -d your-domain.com --non-interactive --agree-tos --email your-email@example.com

echo "Deployment completed successfully!"
echo "Please check the logs for any errors: docker compose logs" 