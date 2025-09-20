1. Запустить minikube

minikube start

2. Создадим namespaces

kubectl create namespace sales
kubectl create namespace utilities
kubectl create namespace finance
kubectl create namespace data
kubectl create namespace platform

3. Проверим namespaces
kubectl get namespaces


4. Запускаем скрипт сертификатов

bash create-certificates.sh

5. Запускаем подтверждение сертификатов

bash apply-csr.sh

6. Создадим роли

kubectl apply -f cluster-viewer-role.yaml
kubectl apply -f sales-developer-role.yaml
kubectl apply -f sales-devops-role.yaml
kubectl apply -f sales-viewer.yaml


7. Применим роли к Ивану и Анне
kubectl apply -f ivan-bind.yaml
kubectl apply -f anna-bind.yaml
