## Prerequisites
- k8s cluster 환경
- k8s환경에 배포된 redis instance

## Reference
- [predixy](https://github.com/joyieldInc/predixy)

## Redis Proxy(predixy) Installation Guide

### 1. namespace 생성
```shell
kubectl create namespace {원하는 namespace 명}
```

### 2. configmap 수정, 생성
predixy-cm.yaml file 내 line 35 부분 수정
```yaml
Servers {
    + {노출한 redis instance의 ip주소. redis cluster의 경우 leader service의 ip주소}
}
```
- 예시
```yaml
Servers {
    + 10.96.220.132:6379
}
```
- 생성
```shell
kubectl apply -f predixy-cm.yaml -n {생성한 namespace 명}
```

### 3. predixy deploy, service(NodePort) 생성
```shell
kubectl apply -f predixy.yaml -n {생성한 namespace 명}
```

## 삭제 Guide
### 1. predixy deploy, service 삭제
```shell
kubectl delete -f predixy.yaml -n {생성한 namespace 명}
```

### 2. configmap 삭제
```shell
kubectl delete -f predixy-cm.yaml -n {생성한 namespace 명}
```