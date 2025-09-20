# create-certificates.sh
#!/usr/bin/env bash
set -euo pipefail

# --- Создание пользователя anna-dev ---
openssl genrsa -out anna-dev.key 2048
openssl req -new -key anna-dev.key -out anna-dev.csr -subj "/CN=anna-dev/O=developers"

# --- Создание пользователя ivan-audit ---
openssl genrsa -out ivan-audit.key 2048
openssl req -new -key ivan-audit.key -out ivan-audit.csr -subj "/CN=ivan-audit/O=audit"

echo "Ключи и CSR для пользователей anna-dev и ivan-audit созданы."
