#!/bin/bash 
xhost +local:root

docker run --name="ros_kimera_librelsense" --rm -it \
--env="DISPLAY"  \
--env="QT_X11_NO_MITSHM=1"  \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--privileged -v /dev:/dev:rw \
--network=host \
--workdir="/catkin_ws/src" \
 dockerforintel/ros-kinetic-kimera-librealsense:latest

xhost -local:root
