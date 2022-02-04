# install-redis-operator
redis-operator(v0.10.0) install guide

## Prerequisites
- k8s(v1.11+) cluster

## Reference
- [redis operator docs](https://ot-container-kit.github.io/redis-operator/guide/installation.html)

## Intallation
- helm으로 설치가 안되는 issue [#17](https://github.com/OT-CONTAINER-KIT/helm-charts/issues/17)
- 따라서 manifest file을 직접 apply하는 방법 사용.
  ```shell
  kubectl apply -f ./manifests/crd/redis-standalone.yaml
  kubectl apply -f ./manifests/crd/redis-cluster.yaml
  kubectl apply -f ./manifests/rbac/serviceaccount.yaml
  kubectl apply -f ./manifests/rbac/role.yaml
  kubectl apply -f ./manifests/rbac/role-binding.yaml
  kubectl apply -f ./manifests/manager.yaml
- 확인
  ```shell
  kubectl get namespace
  ```
  redis-operator 존재 확인
