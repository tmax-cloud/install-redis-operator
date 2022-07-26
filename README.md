# install-redis-operator
redis-operator(v0.9.0) install guide

## Prerequisites
- k8s(v1.11+) cluster

## Reference
- [redis operator docs](https://ot-container-kit.github.io/redis-operator/guide/installation.html)

## Installation
- helm으로 설치가 안되는 issue [#17](https://github.com/OT-CONTAINER-KIT/helm-charts/issues/17)
- 따라서 manifest file을 직접 apply하는 방법 사용.
  ```shell
  kubectl apply -f ./manifests/crd/redis-standalone.yaml
  kubectl apply -f ./manifests/crd/redis-cluster.yaml
  kubectl apply -f ./manifests/rbac/role.yaml
  kubectl apply -f ./manifests/rbac/role-binding.yaml
  kubectl apply -f ./manifests/manager.yaml
  kubectl apply -f ./manifests/rbac/serviceaccount.yaml
- 확인
  ```shell
  kubectl get namespace
  ```
  redis-operator 존재 확인

## 폐쇄망 설치 가이드
- 설치를 진행하기 전 아래의 과정을 통해 필요한 image, yaml file을 준비한다
1. 사용하는 image repository에 설치 시 필요한 image를 push한다.
    - 작업 directory 생성 및 환경 설정
    ```shell
    $ mkdir -p ~/redis-install
    $ export REDIS_HOME=~/redis-install
    $ cd $REDIS_HOME
    $ export REDIS_OPERATOR_VERSION=v0.10.0
    $ export REDIS_VERSION=v6.2.5
    $ export REDIS_EXPORTER_VERSION=1.0
    $ export REDIS_INSIGHT_VERSION=latest
    $ export REDIS_PROXY_VERSION=latest
    $ export REGISTRY={ImageRegistryIP:Port}
    ```

    - 외부 network 통신이 가능한 환경에서 필요한 image를 download 후 압축해 저장한다.
    ```shell
    $ sudo docker pull quay.io/opstree/redis-operator:${REDIS_OPERATOR_VERSION}
    $ sudo docker save quay.io/opstree/redis-operator:${REDIS_OPERATOR_VERSION} > redis_operator_${REDIS_OPERATOR_VERSION}.tar

    $ sudo docker pull quay.io/opstree/redis:${REDIS_VERSION}
    $ sudo docker save quay.io/opstree/redis:${REDIS_VERSION} > redis_${REDIS_VERSION}.tar

    $ sudo docker pull quay.io/opstree/redis-exporter:${REDIS_EXPORTER_VERSION}
    $ sudo docker save quay.io/opstree/redis-exporter:${REDIS_EXPORTER_VERSION} > redis_exporter_${REDIS_EXPORTER_VERSION}.tar

    $ sudo docker pull docker.io/redislabs/redisinsight:${REDIS_INSIGHT_VERSION}
    $ sudo docker save docker.io/redislabs/redisinsight:${REDIS_INSIGHT_VERSION} > redisinsight_${REDIS_INSIGHT_VERSION}.tar

    $ sudo docker pull docker.io/tmaxcloudck/redis-cluster-proxy:${REDIS_PROXY_VERSION}
    $ sudo docker save docker.io/tmaxcloudck/redis-cluster-proxy:${REDIS_PROXY_VERSION} > redis_cluster_proxy_${REDIS_PROXY_VERSION}.tar
    ```

2. 위의 과정에서 생성한 tar file들을 폐쇄망 환경으로 이동시킨 뒤 사용하려는 registry에 image를 push한다.
    ```shell
    $ sudo docker load < redis_operator_${REDIS_OPERATOR_VERSION}.tar
    $ sudo docker load < redis_${REDIS_VERSION}.tar
    $ sudo docker load < redis_exporter_${REDIS_EXPORTER_VERSION}.tar
    $ sudo docker load < redisinsight_${REDIS_INSIGHT_VERSION}.tar
    $ sudo docker load < redis_cluster_proxy_${REDIS_PROXY_VERSION}.tar

    $ sudo docker tag quay.io/opstree/redis-operator:${REDIS_OPERATOR_VERSION} ${REGISTRY}/opstree/redis-operator:${REDIS_OPERATOR_VERSION}
    $ sudo docker tag quay.io/opstree/redis:${REDIS_VERSION} ${REGISTRY}/opstree/redis:${REDIS_VERSION}
    $ sudo docker tag quay.io/opstree/redis-exporter:${REDIS_EXPORTER_VERSION} ${REGISTRY}/opstree/redis-exporter:${REDIS_EXPORTER_VERSION}
    $ sudo docker tag docker.io/redislabs/redisinsight:${REDIS_INSIGHT_VERSION} ${REGISTRY}/redislabs/redisinsight:${REDIS_INSIGHT_VERSION}
    $ sudo docker tag docker.io/tmaxcloudck/redis-cluster-proxy:${REDIS_PROXY_VERSION} ${REGISTRY}/tmaxcloudck/redis-cluster-proxy:${REDIS_PROXY_VERSION}


    $ sudo docker push ${REGISTRY}/opstree/redis-operator:${REDIS_OPERATOR_VERSION}
    $ sudo docker push ${REGISTRY}/opstree/redis:${REDIS_VERSION}
    $ sudo docker push ${REGISTRY}/opstree/redis-exporter:${REDIS_EXPORTER_VERSION}
    $ sudo docker push ${REGISTRY}/redislabs/redisinsight:${REDIS_INSIGHT_VERSION}
    $ sudo docker push ${REGISTRY}/tmaxcloudck/redis-cluster-proxy:${REDIS_PROXY_VERSION}
    ```
