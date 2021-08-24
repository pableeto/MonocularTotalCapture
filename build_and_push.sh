#Usage: ./build_and_push ${dockerfile_folder} ${image_name}
dockerfile_folder=$1
image_name=$2

docker build ${dockerfile_folder} -t ${image_name}
docker tag ${image_name} pableeto/docker_env:${image_name}
docker push pableeto/docker_env:${image_name}
