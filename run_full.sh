#!/usr/bin/bash
image=pableeto/docker_env:total_capture_demo

set -e
# input param 
# $1: sequence name
# $2: whether the video is upper body only (false by default, enable by -f)
seqName=$1
upperBody=$2

name=${name:-run}
user=${user:-dev}
code=${code:-/home/mcg/MonocularTotalCapture/}
data=${data:-/data/mcgdata}
output=${output:-/data/mcgdata}

#XSOCK=/tmp/.X11-unix
#XAUTH=/tmp/.docker.xauth
#xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
#sudo chmod 777 $XAUTH
#X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
#TCPPORT=`expr 6000 + $X11PORT`
#sudo ufw allow from 172.17.0.0/16 to any port $TCPPORT proto tcp 
#DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`

#xhost +
XAUTH=$HOME/.Xauthority
docker pull ${image}
docker run --rm \
	--privileged \
	--user ${user} \
	--mount type=bind,source=${code},target=/workspace \
	--mount type=bind,source=${data},target=/mnt/data \
	--mount type=bind,source=${output},target=/experiments \
	--gpus 0 \
	--shm-size 32G \
	--network host \
        -v $XAUTH:/home/dev/.Xauthority \
        -e DISPLAY=$DISPLAY \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        --name ${name} -it ${image} bash /workspace/run_first_half.sh ${seqName} ${upperBody}

./bash run_second_half.sh ${seqName} ${upperBody}