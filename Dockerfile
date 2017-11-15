FROM armhf-devel-ubuntu16.04-jp:latest

# ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update && \
    apt-get install -y ros-kinetic-ros-base \
                       ros-kinetic-desktop \
                       ros-kinetic-desktop-full
RUN apt-get install -y ros-kinetic-moveit \
                       ros-kinetic-octomap \
                       ros-kinetic-usb-cam \
                       ros-kinetic-openni2-launch \
                       ros-kinetic-ros-control \
                       ros-kinetic-ros-controllers
RUN apt-get install -y ros-kinetic-gazebo-ros-pkgs \
                       ros-kinetic-gazebo-ros-control \
                       ros-kinetic-kobuki-gazebo \
                       ros-kinetic-turtlebot-gazebo
RUN apt-get install -y ros-kinetic-rosbridge-server \
                       ros-kinetic-web-video-server \
                       ros-kinetic-tf2-web-republisher \
                       ros-kinetic-interactive-marker-proxy
RUN rosdep init && rosdep update && \
    apt-get install -y python-rosinstall && \
    apt-get clean && apt-get auto-remove
## Gazebo
#WORKDIR /tmp
#RUN apt-get install mercurial
#RUN hg clone https://bitbucket.org/osrf/gazebo_models && \
#    mkdir -p $HOME/.gazebo/models/ && \
#    cp -r gazebo_models/* $HOME/.gazebo/models/ && \
#    rm -r gazebo_models
# ROS Settings
RUN mkdir -p $HOME/catkin_ws/src
WORKDIR /root/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_init_workspace'
WORKDIR /root/catkin_ws/
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_make' && \
    echo "source /opt/ros/kinetic/setup.bash" >> $HOME/.bashrc && \
    echo "source ~/catkin_ws/devel/setup.bash" >> $HOME/.bashrc

# QtCreator ROS
RUN add-apt-repository -y ppa:levi-armstrong/qt-libraries-xenial && \
    add-apt-repository -y ppa:levi-armstrong/ppa && \
    apt update && apt install -y qt59creator && \
    apt install -y qt57creator-plugin-ros

WORKDIR /root/catkin_ws
CMD ["/bin/bash"]

