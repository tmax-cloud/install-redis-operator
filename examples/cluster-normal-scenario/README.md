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
chmod 777 install.sh
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
    NAME                 READY   STATUS    RESTARTS   AGE
    example-follower-0   1/1     Running   0          4m57s
    example-follower-1   1/1     Running   0          4m26s
    example-follower-2   1/1     Running   0          3m56s
    example-leader-0     1/1     Running   0          4m57s
    example-leader-1     1/1     Running   0          4m27s
    example-leader-2     1/1     Running   0          3m56s
    ```
- container접속
    ```shell
    kubectl exec -it example-leader-0 -n {생성한 namespace 명} -- bash
    ```
- nodes.conf확인
    ```shell
    bash-4.4# cat nodes.conf 
    185bad5799d5c9fa2b1b1c42c5f48fea5fae4426 10.244.128.168:6379@16379 slave 38d79b7249f47539b353785ebd5d1f177f2e526f 0 1647482329296 1 connected
    730b566e5e1b9308bba25d61bed6eefb4e7ec813 10.244.128.151:6379@16379 master - 0 1647482330299 2 connected 5461-10922
    c6174a5b9a36d5e8af0c6a749405a7bfc05ccbe6 10.244.105.56:6379@16379 master - 0 1647482329000 3 connected 10923-16383
    aaa5dcbdfcfc675c7a4a1925cb60a2fbdafa1cb7 10.244.136.200:6379@16379 slave c6174a5b9a36d5e8af0c6a749405a7bfc05ccbe6 0 1647482330399 3 connected
    38d79b7249f47539b353785ebd5d1f177f2e526f 10.244.136.214:6379@16379 myself,master - 0 1647482328000 1 connected 0-5460
    498250e10e09c5193d731ac88f5a1c74c8fd90b1 10.244.105.1:6379@16379 slave 730b566e5e1b9308bba25d61bed6eefb4e7ec813 0 1647482329000 2 connected
    vars currentEpoch 12 lastVoteEpoch 0
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
    127.0.0.1:6379> cluster info
    cluster_state:ok
    cluster_slots_assigned:16384
    cluster_slots_ok:16384
    cluster_slots_pfail:0
    cluster_slots_fail:0
    cluster_known_nodes:6
    cluster_size:3
    cluster_current_epoch:12
    cluster_my_epoch:1
    cluster_stats_messages_ping_sent:732
    cluster_stats_messages_pong_sent:722
    cluster_stats_messages_sent:1454
    cluster_stats_messages_ping_received:719
    cluster_stats_messages_pong_received:727
    cluster_stats_messages_meet_received:3
    cluster_stats_messages_received:1449
    ```

