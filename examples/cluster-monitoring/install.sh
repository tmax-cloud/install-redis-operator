#!/bin/bash
ALL_CMD=`kubectl get nodes`
CMD_LIST=()
HOST_NAME_LIST=()

for i in $ALL_CMD; do CMD_LIST+=($i); done

for i in "${!CMD_LIST[@]}"
do
    surplus=$(($i % 5))
    surplus2=$(($i / 5 * 5 + 2))
    if [ $surplus == 0 ] && [ ${CMD_LIST[$i]} != "NAME" ];then
        if [[ "${CMD_LIST[$surplus2]}" != *master* ]] && [ "${CMD_LIST[$surplus2]}" != "ROLES" ] ;then
            HOST_NAME_LIST+=(${CMD_LIST[$i]})
        fi
    fi
done

echo "==== HOST NAMES FOR WORKER NODES ===="
echo ${HOST_NAME_LIST[@]}

HOST_NAME1="${HOST_NAME_LIST[0]}"
HOST_NAME2="${HOST_NAME_LIST[1]}"
HOST_NAME3="${HOST_NAME_LIST[2]}"

echo "APPLY HOST NAMES FOR WORKER NODES TO PV. . ."
sed -i 's/{HOST_NAME1}/'${HOST_NAME1}'/g' leader-pv.yaml
sed -i 's/{HOST_NAME2}/'${HOST_NAME2}'/g' leader-pv.yaml
sed -i 's/{HOST_NAME3}/'${HOST_NAME3}'/g' leader-pv.yaml

sed -i 's/{HOST_NAME1}/'${HOST_NAME1}'/g' follower-pv.yaml
sed -i 's/{HOST_NAME2}/'${HOST_NAME2}'/g' follower-pv.yaml
sed -i 's/{HOST_NAME3}/'${HOST_NAME3}'/g' follower-pv.yaml
echo "APPLY COMPLETE"