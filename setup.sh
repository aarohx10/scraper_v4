#!/bin/bash

# Exit on error
set -e

echo "Starting setup process..."

# Create necessary directories
mkdir -p data/certbot/conf
mkdir -p data/certbot/www
mkdir -p logs
mkdir -p /root/backups

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOL
# Application Settings
APP_ENV=production
DEBUG=false
HOST=0.0.0.0
PORT=8000

# Security Settings
ALLOWED_ORIGINS=*
CORS_ORIGINS=*

# Rate Limiting
RATE_LIMIT_PER_MINUTE=60

# Logging
LOG_LEVEL=INFO
LOG_FILE=/app/data/app.log
EOL
fi

# Make scripts executable
chmod +x deploy.sh
chmod +x backup.sh
chmod +x healthcheck.sh
chmod +x setup.sh

# Create log files with proper permissions
touch logs/app.log
chmod 666 logs/app.log

# Set up backup cron job
(crontab -l 2>/dev/null; echo "0 2 * * * $(pwd)/backup.sh") | crontab -

echo "Setup completed successfully!"
echo "You can now run ./deploy.sh to deploy the application" 