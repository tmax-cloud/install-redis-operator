## Prerequisites
- k8s cluster 환경
- k8s환경에 배포된 redis instance

## Architecture
![Redis Cluster Proxy](https://user-images.githubusercontent.com/22141521/163504514-b03e1b19-aff2-404a-aad2-2a24e73c01da.png)

## Reference
- [Redis Cluster Proxy](https://github.com/RedisLabs/redis-cluster-proxy)

## Redis Cluster Proxy(Redis Cluster Proxy) Installation Guide

### 1. namespace 생성
```shell
kubectl create namespace {원하는 namespace 명}
```

### 2. file 수정
kornrunner.yaml file 내 line 34 부분 수정
```yaml
command: ["/usr/local/bin/redis-cluster-proxy", "leader service의 ip주소:6379"]
```

### 3. deployment, service(NodePort) 생성
```shell
kubectl apply -f kornrunner.yaml -n {생성한 namespace 명}
```

## 삭제 Guide
### 1. kornrunner deploy, service 삭제
```shell
kubectl delete -f kornrunner.yaml -n {생성한 namespace 명}
```
