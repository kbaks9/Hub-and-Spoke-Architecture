# #!/bin/bash
# set -e

# max_attempts=12   # 12 * 5s = 60s max wait
# attempt=0

# until curl -Is http://azure.archive.ubuntu.com >/dev/null 2>&1; do
#     attempt=$((attempt + 1))
#     if [ "$attempt" -ge "$max_attempts" ]; then
#         echo "ERROR: No outbound connectivity after $((max_attempts * 5)) seconds. Exiting."
#         exit 1
#     fi
#     echo "Waiting for outbound connectivity... (attempt $attempt/$max_attempts)"
#     sleep 5
# done

# apt-get update
# apt-get install -y apache2

# systemctl enable apache2
# systemctl start apache2

# echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html

{
  echo "=== DNS test ==="
  nslookup azure.archive.ubuntu.com

  echo "=== Route table ==="
  ip route

  echo "=== Curl test (15s timeout) ==="
  curl -v --max-time 15 http://azure.archive.ubuntu.com
} > /tmp/network-test.log 2>&1