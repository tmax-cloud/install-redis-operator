## Prerequisites
- k8s cluster 환경 : 3개 이상의 worker node
- cluster size : 3이상

## Redis Cluster Monitoring Installation Guide
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
    NAME                                     READY   STATUS    RESTARTS   AGE
    example-monitoring-external-follower-0   2/2     Running   0          78s
    example-monitoring-external-follower-1   2/2     Running   0          59s
    example-monitoring-external-follower-2   2/2     Running   0          33s
    example-monitoring-external-leader-0     2/2     Running   0          81s
    example-monitoring-external-leader-1     2/2     Running   0          50s
    example-monitoring-external-leader-2     2/2     Running   0          29s
    ```
- container접속
    ```shell
    kubectl exec -it example-monitoring-leader-0 -n {생성한 namespace 명} -- bash
    ```
- nodes.conf확인
    ```shell
    bash-4.4# cat nodes.conf 
    0c7cbca07834d01723b9fc0ee7ce996d2d36bb6e 10.244.222.249:6379@16379 master - 0 1647837585000 16 disconnected 10923-16383
    395e0fde6d4349eb4c5e6dd721423a7e3aa7e584 10.244.48.84:6379@16379 slave 9557e0888fb2f1661fbf40230ea2c49a86a56dc2 0 1647837585000 1 connected
    b731bfec0f5f5f03e0c3316906af481d1e9619d8 10.244.48.109:6379@16379 master - 0 1647837585000 2 connected 5461-10922
    9557e0888fb2f1661fbf40230ea2c49a86a56dc2 10.244.235.25:6379@16379 myself,master - 0 1647837585000 1 connected 0-5460
    6afbca299ed1a4a15ab32795aa5f88732e60003f 10.244.222.248:6379@16379 slave b731bfec0f5f5f03e0c3316906af481d1e9619d8 0 1647837585589 2 connected
    1e6eb9f70b2f9777807141bfa1e4bd25b025b6a3 10.244.235.14:6379@16379 slave 0c7cbca07834d01723b9fc0ee7ce996d2d36bb6e 0 1647837585687 16 connected
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
    cluster_stats_messages_ping_sent:263
    cluster_stats_messages_pong_sent:244
    cluster_stats_messages_sent:507
    cluster_stats_messages_ping_received:244
    cluster_stats_messages_pong_received:263
    cluster_stats_messages_received:507
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
4. localstorage 삭제
kubectl delete -f storage.yaml -n {생성한 namespace 명}