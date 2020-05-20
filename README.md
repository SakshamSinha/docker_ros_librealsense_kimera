# Instructions
Docker repo for details on how to use docker image hosted on docker hub

* Start the container by running the following-
```buildoutcfg
    ./run-session.sh
```
This will run the container with the GUI support as well as mount necessary drivers to mount Realsense D435i and T265 cameras in docker image.


* We need four terminals to run the demo. So we will be using tmux. We could have gone through the docker exec route but that will require to source ros in all the terminals. Tmux is much better for me.
```buildoutcfg
    root@hostname:/catkin_ws/src# tmux
```
This will open tmux on the terminal. At this point expand your terminal window to full screen to properly see the window.
Since tmux is set up with *default key bindings*, to split the windows we will be pressing following keys at a time-

* **Ctrl+B "** to split the terminal horizontally and 
* **Ctrl+B %** to split the terminal vertically.

Once you have done that you will have four terminals. To navigate among these terminals, 
you will need to press following keys-

* **Ctrl+B ←** to go to left terminal
* **Ctrl+B →** to go to right terminal
* **Ctrl+B ↑** to go to top terminal
* **Ctrl+B ↓** to go to bottom terminal 

In order to run the demo, 
on the top left terminal we will start the roscore as it is always a good practice to do so.
```buildoutcfg  
    roscore &
```  
This will run the roscore in background.

Now in the same terminal, we will start the realsense D435i camera-
```
roslaunch realsense2_camera rs_camera.launch unite_imu_method:=linear_interpolation
```

The RealSense has an IR emitter on it to improve its RGBD stream. This creates undesirable dots on the infrared images. Hence to fix this, in the top right terminal, we will run-
```
rosrun dynamic_reconfigure dynparam set /camera/stereo_module emitter_enabled 0
```

We will now launch Kimera-VIO-ROS wrapper by typing the following in the same terminl-
```
roslaunch kimera_vio_ros kimera_vio_ros_realsense_IR.launch
```
It is important to remember that when launching the VIO, the camera should be standing still and upward (camera fov forward looking).

And finally we will visualize the trajectory by rviz. For doing this, we will type the following in bottom left terminal
```
rviz -d $(rospack find kimera_vio_ros)/rviz/kimera_vio_euroc.rviz
```
