## iCub skin simulation container

Container build commands
```
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -
docker build --build-arg ICUB_SKIN_VER=$(date +%s) --build-arg user=$USER --build-arg uid=$(id -u) --build-arg gid=$(id -g) -t icub-skin-container .
docker run -it -p 11345:11345 -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth --name=gazebo -t icub-skin-container
```

Proposed papers
* https://openreview.net/pdf?id=HyxAfnA5tm