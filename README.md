# install-redis-operator
redis-operator(v0.10.0) install guide

## Prerequisites
- k8s(v1.11+) cluster

## Reference
- [redos operator docs](https://ot-container-kit.github.io/redis-operator/guide/installation.html)

## Intallation
- helm으로 설치가 안되는 issue [#17](https://github.com/OT-CONTAINER-KIT/helm-charts/issues/17)
- 따라서 대용으로 Reference의 최하단에서 manifest file을 직접 apply하는 방법 사용 상단 manifest folder참조
- 확인
  ```shell
  kubectl get namespace