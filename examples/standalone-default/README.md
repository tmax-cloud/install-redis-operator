## Prerequisite
k8s cluster(v1.11+)

## Reference
- [redis-standalone](https://ot-container-kit.github.io/redis-operator/guide/redis-config.html)
## Redis Standalone Installation Guide
### 1. namespace 생성
```shell
kubectl create namespace {원하는 namespace 명}
```
### 2. secret 생성
```shell
kubectl apply -f secret.yaml -n {생성한 namespace 명}
```

### 3. redis standalone 생성
```shell
kubectl apply -f standalone.yaml -n {생성한 namespace 명}
```