## Examples
- redis-secret이 반드시 먼저 생성되어 있어야 함
    - 다음 명령어로 생성
        ```shell
        kubectl apply -f redis-secret.yaml
        
- [redis-standalone](https://ot-container-kit.github.io/redis-operator/guide/redis-config.html)
    - 다음 명령어로 생성
        ```shell
        kubectl apply -f redis-standalone.yaml
        
- [redis-cluister](https://ot-container-kit.github.io/redis-operator/guide/redis-cluster-config.html#helm-parameters)
    - 다음 명령어로 생성
        ```shell
        kubectl apply -f redis-cluster.yaml
