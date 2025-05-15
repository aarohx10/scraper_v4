#!/bin/bash

# Check if the application is responding
curl -f http://localhost:8000/health || exit 1

# Check if the process is running
ps aux | grep uvicorn | grep -v grep || exit 1

# Check if the port is open
netstat -tuln | grep :8000 || exit 1

exit 0 