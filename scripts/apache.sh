#!/bin/bash
set -e

until curl -Is http://azure.archive.ubuntu.com >/dev/null 2>&1; do
    echo "Waiting for outbound connectivity..."
    sleep 5
done

apt-get update
apt-get install -y apache2

systemctl enable apache2
systemctl start apache2

echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html