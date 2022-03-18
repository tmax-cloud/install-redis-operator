## Prerequisites
- k8s cluster 환경 : 3개 이상의 worker node
- cluster size : 3이상

## Redis Cluster Installation Guide
### 1. namespace 생성
```shell
kubectl create namespace {원하는 namespace 명}
```

### 2. localstorage 생성
```shell
kubectl apply -f storage.yaml
```

### 3. 각 worker node에 ssh접속 후 다음을 수행
3-1. root 경로로 이동
```shell
    cd /
```
3-2. follower, leader folder 생성
```shell
mkdir follower
mkdir leader
```

### 4. redis secret 생성
```shell
kubectl apply -f secret.yaml -n {생성한 namespace 명}
```

### 5. install.sh 권한 부여 후 실행

```shell
chmod +x install.sh
./install.sh
```

### 6. leader pv 생성
```shell
kubectl apply -f leader-pv.yaml -n {생성한 namespace 명}
```

### 7. follower pv 생성
```shell
kubectl apply -f follower-pv.yaml -n {생성한 namespace 명}
```

### 8. example cluster 생성
```shell
kubectl apply -f local-example-cluster.yaml -n {생성한 namespace 명}
```

### 9. 정상 생성 확인
- pod 생성 확인 명령어
    ```shell
    kubectl get pods -n {생성한 namespace 명}
    ```

- 출력결과
    ```shell
    NAME                            READY   STATUS    RESTARTS   AGE
    example-monitoring-follower-0   2/2     Running   0          18m
    example-monitoring-follower-1   2/2     Running   0          18m
    example-monitoring-follower-2   2/2     Running   0          17m
    example-monitoring-leader-0     2/2     Running   0          18m
    example-monitoring-leader-1     2/2     Running   0          18m
    example-monitoring-leader-2     2/2     Running   0          17m
    ```
- container접속
    ```shell
    kubectl exec -it example-monitoring-leader-0 -n {생성한 namespace 명} -- bash
    ```
- nodes.conf확인
    ```shell
    bash-4.4# cat nodes.conf 
    6afbca299ed1a4a15ab32795aa5f88732e60003f 10.244.222.189:6379@16379 slave adbb3c32d6ddd37e9774f2483c19e94d4861b0d6 0 1647578367566 2 connected
    2eabbcc3dd338267fcea40f1cf0ae95badf6fe6a 10.244.71.255:6379@16379 slave 9557e0888fb2f1661fbf40230ea2c49a86a56dc2 0 1647578367564 1 connected
    0c7cbca07834d01723b9fc0ee7ce996d2d36bb6e 10.244.222.157:6379@16379 master - 0 1647578366564 11 connected 10923-16383
    adbb3c32d6ddd37e9774f2483c19e94d4861b0d6 10.244.71.217:6379@16379 master - 0 1647578368064 2 connected 5461-10922
    9557e0888fb2f1661fbf40230ea2c49a86a56dc2 10.244.235.56:6379@16379 myself,master - 0 1647578367000 1 connected 0-5460
    1e6eb9f70b2f9777807141bfa1e4bd25b025b6a3 10.244.235.61:6379@16379 slave 0c7cbca07834d01723b9fc0ee7ce996d2d36bb6e 0 1647578368563 11 connected
    vars currentEpoch 11 lastVoteEpoch 0
    ```
- redis cli 실행
    ```shell
    bash-4.4# redis-cli
    127.0.0.1:6379> 
    ```
- 생성한 redis secret의 stringData.password 값 입력
    ```shell
    127.0.0.1:6379> auth 123==
    OK
    ```
- cluster info 확인
    ```shell
    cluster_state:ok
    cluster_slots_assigned:16384
    cluster_slots_ok:16384
    cluster_slots_pfail:0
    cluster_slots_fail:0
    cluster_known_nodes:6
    cluster_size:3
    cluster_current_epoch:11
    cluster_my_epoch:1
    cluster_stats_messages_ping_sent:1764
    cluster_stats_messages_pong_sent:1748
    cluster_stats_messages_sent:3512
    cluster_stats_messages_ping_received:1745
    cluster_stats_messages_pong_received:1760
    cluster_stats_messages_meet_received:3
    cluster_stats_messages_received:3508
    ```

## 삭제 Guide
1. cluster 삭제
kubectl delete -f local-example-cluster.yaml -n {생성한 namespace 명}
2. leader-pv 삭제
kubectl delete -f leader-pv.yaml -n {생성한 namespace 명}
3. follower-pv 삭제
kubectl delete -f follower-pv.yaml -n {생성한 namespace 명}
4. secret 삭제
kubectl delete -f secret.yaml -n {생성한 namespace 명}
5. localstorage 삭제
kubectl delete -f storage.yaml -n {생성한 namespace 명}