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

### 4. install.sh 권한 부여 후 실행

```shell
chmod +x install.sh
./install.sh
```

### 5. leader pv 생성
```shell
kubectl apply -f leader-pv.yaml -n {생성한 namespace 명}
```

### 6. follower pv 생성
```shell
kubectl apply -f follower-pv.yaml -n {생성한 namespace 명}
```

### 7. service 객체 생성
```shell
kubectl apply -f cluster-svc.yaml -n {생성한 namespace 명}
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
    NAME                          READY   STATUS    RESTARTS   AGE
    example-external-follower-0   1/1     Running   0          85s
    example-external-follower-1   1/1     Running   0          51s
    example-external-follower-2   0/1     Running   0          24s
    example-external-leader-0     1/1     Running   0          88s
    example-external-leader-1     1/1     Running   0          66s
    example-external-leader-2     1/1     Running   0          43s
    ```
- container접속
    ```shell
    kubectl exec -it example-external-leader-0 -n {생성한 namespace 명} -- bash
    ```
- nodes.conf확인
    ```shell
    bash-4.4# cat nodes.conf 
    99c260b87e40a6903f3e4dadde43d372e9525bf1 10.244.71.69:6379@16379 master - 0 1647826181390 3 connected 10923-16383
    abf8ba450aafe96961926797e5ec419bc0768666 10.244.71.71:6379@16379 slave b731bfec0f5f5f03e0c3316906af481d1e9619d8 0 1647826180333 2 connected
    395e0fde6d4349eb4c5e6dd721423a7e3aa7e584 10.244.48.77:6379@16379 slave 9557e0888fb2f1661fbf40230ea2c49a86a56dc2 0 1647826180000 1 connected
    75ab2da0d7c22e5ebabb612c767862e018864b6f 10.244.235.14:6379@16379 slave 99c260b87e40a6903f3e4dadde43d372e9525bf1 0 0 3 disconnected
    b731bfec0f5f5f03e0c3316906af481d1e9619d8 10.244.48.81:6379@16379 master - 0 1647826180386 2 connected 5461-10922
    9557e0888fb2f1661fbf40230ea2c49a86a56dc2 10.244.235.1:6379@16379 myself,master - 0 1647826180000 1 connected 0-5460
    vars currentEpoch 16 lastVoteEpoch 0
    ```
- redis cli 실행
    ```shell
    bash-4.4# redis-cli
    127.0.0.1:6379> 
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
    cluster_current_epoch:20
    cluster_my_epoch:1
    cluster_stats_messages_ping_sent:380
    cluster_stats_messages_pong_sent:360
    cluster_stats_messages_sent:740
    cluster_stats_messages_ping_received:357
    cluster_stats_messages_pong_received:376
    cluster_stats_messages_meet_received:3
    cluster_stats_messages_received:736
    ```
- prometheus에서 metric 정보 확인
    - prometheus가 cluster 외부노출된 상태라면 browser접속 가능
    - "redis_exporter_last_scrape_connect_time_seconds" query작성
    - execute button click
    - graph tab에서 다음 정보 확인
    ![image](https://user-images.githubusercontent.com/22141521/158940771-a8b7349d-5e6f-4b10-9066-72b742ee2eb8.png)

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