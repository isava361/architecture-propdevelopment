# apply-csr.sh
#!/usr/bin/env bash
set -euo pipefail

# Гарантируем наличие файлов
for u in anna-dev ivan-audit; do
  [[ -f "$u.key" && -f "$u.csr" ]] || { echo "Нет $u.key или $u.csr. Сначала запустите create-certificates.sh"; exit 1; }
done


# Функция: создать CSR → одобрить → получить сертификат
create_and_issue() {
  local u="$1"; local csr_name="${u}-csr"
  local csr_b64
  csr_b64="$(base64 < "${u}.csr" | tr -d '\n')"

  # Создаём CSR через here-doc
  cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${csr_name}
spec:
  signerName: kubernetes.io/kube-apiserver-client
  request: ${csr_b64}
  usages:
  - client auth
EOF

  # Одобряем
  kubectl certificate approve "${csr_name}"

  # Ждём, пока контроллер выдаст сертификат
  for i in {1..30}; do
    cert="$(kubectl get csr "${csr_name}" -o jsonpath='{.status.certificate}' || true)"
    if [[ -n "$cert" ]]; then
      echo "$cert" | base64 -d > "${u}.crt"
      break
    fi
    sleep 1
  done
  [[ -s "${u}.crt" ]] || { echo "Не дождались выдачи сертификата для ${u}"; exit 1; }
}

create_and_issue anna-dev
create_and_issue ivan-audit

# Настраиваем kubeconfig
kubectl config set-credentials anna-dev \
  --client-key="$(pwd)/anna-dev.key" \
  --client-certificate="$(pwd)/anna-dev.crt" \
  --embed-certs=true

kubectl config set-context anna-dev-context \
  --cluster=minikube \
  --user=anna-dev \
  --namespace=sales

kubectl config set-credentials ivan-audit \
  --client-key="$(pwd)/ivan-audit.key" \
  --client-certificate="$(pwd)/ivan-audit.crt" \
  --embed-certs=true

kubectl config set-context ivan-audit-context \
  --cluster=minikube \
  --user=ivan-audit

echo "Готово: контексты anna-dev-context и ivan-audit-context настроены."
