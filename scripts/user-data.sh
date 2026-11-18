#!/bin/bash
set -euo pipefail

# Логирование
exec > >(tee /var/log/user-data.log) 2>&1
echo "=== Starting user-data script at $(date) ==="

# Обновление системы
dnf update -y

# Установка Docker
dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user

# Установка полезных утилит
dnf install -y curl wget git htop

# Простой health-check endpoint через nginx (или можно поднять docker)
# Для демо поднимаем простой python http-server, но лучше docker

# Создаём простой health endpoint
cat > /usr/local/bin/health-server.py << 'EOF'
#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import time

START = time.time()

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path in ("/health", "/"):
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            body = json.dumps({
                "status": "healthy",
                "uptime": round(time.time() - START, 2),
                "hostname": __import__("socket").gethostname()
            })
            self.wfile.write(body.encode())
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        pass

HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
EOF

chmod +x /usr/local/bin/health-server.py

# systemd unit
cat > /etc/systemd/system/health-app.service << 'EOF'
[Unit]
Description=Simple Health App
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/health-server.py
Restart=always
RestartSec=3
User=ec2-user

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now health-app.service

echo "=== User-data finished successfully at $(date) ==="
