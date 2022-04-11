## Prerequisites
- k8s cluster 환경

## Reference
- [redis-insight](https://docs.redis.com/latest/ri/)

## Redis Default Cluster Installation Guide
### 1. namespace 생성
```shell
kubectl create namespace {원하는 namespace 명}
```

### 2. pvc 생성 (DefaultStorageClass 사용, redis 접속정보를 저장하기 위해)
```shell
kubectl apply -f insight-pvc.yaml -n {생성한 namespace 명}
```

### 3. redis insight deploy, service 생성
```shell
kubectl apply -f insight.yaml -n {생성한 namespace 명}
```

## 삭제 Guide
### 1. redis insight deploy, service  삭제
```shell
kubectl delete -f insight.yaml -n {생성한 namespace 명}
```

### 2. pvc 삭제
```shell
kubectl delete -f insight-pvc.yaml -n {생성한 namespace 명}
```