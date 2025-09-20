1. Создадим сервисы внутри namespace - finance
```bash
kubectl -n finance run front-end-app --image=nginx --labels role=front-end --port=80 --expose
```
```bash
kubectl -n finance run back-end-api-app --image=nginx --labels role=back-end-api --port=80 --expose
```
```bash
kubectl -n finance run admin-front-end-app --image=nginx --labels role=admin-front-end --port=80 --expose
```
```bash
kubectl -n finance run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --port=80 --expose
```

2. Применяем политику
```bash
kubectl apply -f api-allow.yaml
```

3. Проверяем работу
Тестовый под с пометкой admin-front-end
```bash
kubectl -n finance run test-admin-fe --rm -it --image=alpine --labels role=admin-front-end -- sh
```
Стучимся в admin-back-end
```bash
wget -qO- --timeout=2 http://admin-back-end-api-app
```
Ожидаем что скачали файл

Стучимся в back-end
```bash
wget -qO- --timeout=2 http://back-end-api-app
```
Ожидаем таймаут

```bash
exit
```

Тестовый под с пометкой front-end
```bash
kubectl -n finance run test-fe --rm -it --image=alpine --labels role=front-end -- sh
```
Стучимся в admin-back-end
```bash
wget -qO- --timeout=2 http://admin-back-end-api-app
```
Ожидаем таймаут

Стучимся в back-end
```bash
wget -qO- --timeout=2 http://back-end-api-app
```
Ожидаем скачанный файл
```bash
exit
```
