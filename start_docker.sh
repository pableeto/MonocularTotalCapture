#Usage: ./start_env.sh [--code /path/to/code] [--data /path/to/data] [--user username] [--image image] [--name container_name]
image=pableeto/docker_env:total_capture_demo
name=${name:-total_capture}
user=${user:-dev}
code=${code:-/data/mcgdata/code_xiao}
data=${data:-/data/mcgdata}
output=${output:-/data/mcgdata}

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

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
	--shm-size 16G \
	--network host \
        -v $XAUTH:/home/dev/.Xauthority \
        -e DISPLAY=$DISPLAY \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        --name ${name} -it ${image} bash
# docker run --gpus 0 -it \
#     -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -e DISPLAY -e XAUTHORITY \
#     -e NVIDIA_DRIVER_CAPABILITIES=all 
#      <docker_image_tag>
