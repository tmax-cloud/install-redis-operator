# install-redis-operator

## Prerequisites
- k8s(v1.11+) cluster & namespace "redis-operator"

## Reference
- [redos operator docs](https://ot-container-kit.github.io/redis-operator/guide/installation.html)

## Intallation
- helm으로 설치가 안되는 issue [#17](https://github.com/OT-CONTAINER-KIT/helm-charts/issues/17)
- 따라서 대용으로 Reference의 최하단에서 manifest file을 직접 apply하는 방법 사용 
  ```shell
  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/crd/bases/redis.redis.opstreelabs.in_redis.yaml

  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/crd/bases/redis.redis.opstreelabs.in_redisclusters.yaml

  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/rbac/serviceaccount.yaml

  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/rbac/role.yaml

  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/rbac/role_binding.yaml

  kubectl apply -f https://raw.githubusercontent.com/OT-CONTAINER-KIT/redis-operator/master/config/manager/manager.yaml

- 확인
  ```shell
  kubectl get namespace