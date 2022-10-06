FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# setup timezone
RUN echo 'America/Santiago' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/America/Santiago /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# Arguments picked from the command line!
ARG user
ARG uid
ARG gid

#Add new user with our credentials
ENV USERNAME ${user}
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod  --uid ${uid} $USERNAME && \
    groupmod --gid ${gid} $USERNAME

RUN apt-get update
RUN apt-get install -y apt-utils gedit x11-apps sudo gnupg

# YARP
RUN sh -c 'echo "deb http://www.icub.org/ubuntu focal contrib/science" > /etc/apt/sources.list.d/icub.list' && \
    sh -c 'echo "deb http://www.icub.org/debian buster contrib/science" > /etc/apt/sources.list.d/icub.list' && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 57A5ACB6110576A6 && \
    apt-get update && apt-get install -y yarp

# ROS noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654  && \
    curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add - && \
    apt update && apt install -y ros-noetic-desktop-full && \
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    apt -y install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential && \
    rosdep init && rosdep update


SHELL ["/bin/bash", "-c"] 