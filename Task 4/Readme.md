1. Запустить minikube

```bash
minikube start --cni=calico
```

2. Создадим namespaces

```bash
kubectl create namespace sales
kubectl create namespace utilities
kubectl create namespace finance
kubectl create namespace data
kubectl create namespace platform
```

3. Проверим namespaces

```bash
kubectl get namespaces
```

4. Запускаем скрипт сертификатов
```bash
bash create-certificates.sh
```

5. Запускаем подтверждение сертификатов
```bash
bash apply-csr.sh
```
6. Создадим роли
```bash
kubectl apply -f cluster-viewer-role.yaml
kubectl apply -f sales-developer-role.yaml
kubectl apply -f sales-devops-role.yaml
kubectl apply -f sales-viewer.yaml
```

7. Применим роли к Ивану и Анне
```bash
kubectl apply -f ivan-bind.yaml
kubectl apply -f anna-bind.yaml
```
