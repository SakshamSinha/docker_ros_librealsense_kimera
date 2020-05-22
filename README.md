# Instructions
Docker repo for details on how to use docker image having Kimera with ROS and Librealsense hosted on [docker hub](https://hub.docker.com/repository/docker/dockerforintel/ros-kinetic-kimera-librealsense "Docker for Kimera, ROS and Librealsense")

* Start the container by running the following-
```buildoutcfg
    ./run-session.sh
```
This will run the container with the GUI support as well as mount necessary drivers to mount Realsense D435i and T265 cameras in docker image.

* It's a good practice to pull the latest changes from the Kimera repositories as it's evolving rapidly.
```buildoutcfg
    root@hostname:/catkin_ws/src# wstool update
``` 

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

## Demo 1 with Kimera VIO and ROS.
In order to run this demo, you will need *Realsense D435i depth camera*.

On the top left terminal we will start the roscore as it is always a good practice to do so.
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
## Demo 2 with Kimera Semantic and ROS with rosbag 
For this demo you will need to download the rosbag from [this link.](https://drive.google.com/file/d/1SG8cfJ6JEfY2PGXcxDPAMYzCcGBEh4Qq/view?usp=sharing "Demo Rosbag hosted by Kimera Semantic development team")

* We'll begin with modifying the run_session.sh script to mount the folder with the rosbag downloaded from the above link to */kimera_semantics_ros/rosbag/* folder
```buildoutcfg
    --volume="Complete_path_to_rosbag_folder:/catkin_ws/src/Kimera-Semantics/kimera_semantics_ros/rosbags:rw" \
```

* We will now start the container by-
```buildoutcfg
    ./run-session.sh
``` 
* Once the container has started, we will start a tmux session and create 2 terminals as described earlier. Start the roscore in background as described in Demo 1.

* In th same terminal, we will now launch kimera semantic with the rosbag downloaded earlier-
```buildoutcfg
    roslaunch kimera_semantics_ros kimera_semantics.launch play_bag:=true
``` 

* To visualize, we will start the rviz in the another terminal-
```buildoutcfg
    rviz -d $(rospack find kimera_semantics_ros)/rviz/kimera_semantics_gt.rviz
```

## Demo 3 with Kimera Semantic 3D reconstruction without semantic annotations with Realsense D435i.

* We will require five terminals in tmux session for this demo. We will first follow all the septs from Demo 1. Once completed we will start with below steps-

* We will launch the Kimera Semantic to work with Realsense D435i to do real time 3D Reconstruction. This uses Voxblox library to do the reconstruction. -
``` buildoutcfg
    roslaunch kimera_semantics_ros kimera_metric_realsense.launch register_depth:=true  
```

* We will now visualize the output by typing-
``` buildoutcfg
    rviz -d $(rospack find kimera_semantic_ros)/rviz/kimera_realsense_metric.rviz
```
**Note** You may need to change the global frame to world and add Voxblox Mesh topic in rviz to visualize the mesh. 

* If you wish to save your mesh you can do so by calling the rosservice as below-
```buildoutcfg
    rosservice call /kimera_semantics_node/generate_mesh
```

This will save the mesh as .ply file in *mesh_results* folder. You can view this file by typing-
```buildoutcfg
    paraview filename.ply
```
Once started, you will need to click on apply to view the mesh.