FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# setup timezone
RUN echo 'America/Santiago' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/America/Santiago /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y apt-utils x11-apps sudo gnupg git wget curl build-essential htop

# Python
RUN apt install -y python3 python3-dev python3-pip python3-setuptools && \
    if [ ! -f "/usr/bin/python" ]; then ln -s /usr/bin/python3 /usr/bin/python; fi

# Select options
ARG ROBOTOLOGY_SUPERBUILD_RELEASE=v2022.09.0
ARG BUILD_TYPE=Release
ARG ROBOTOLOGY_SUPERBUILD_INSTALL_DIR=/usr/local

# Set up git (required by superbuild)
RUN git config --global user.name "GitHub Actions" && \
    git config --global user.email "actions@github.com"

RUN git clone https://github.com/robotology/robotology-superbuild.git --depth 1 --branch ${ROBOTOLOGY_SUPERBUILD_RELEASE} && \
    robotology-superbuild/scripts/install_apt_dependencies.sh

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | tee /etc/apt/trusted.gpg.d/gazebo.asc && \
    apt-get update && \
    apt-get install -y gazebo11 libgazebo11-dev

# Build robotology-superbuild
RUN cd robotology-superbuild && \
    mkdir build && cd build && \
    cmake .. \
          -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
          -DYCM_EP_INSTALL_DIR=${ROBOTOLOGY_SUPERBUILD_INSTALL_DIR} \
          -DROBOTOLOGY_ENABLE_CORE:BOOL=ON \
          -DROBOTOLOGY_ENABLE_ROBOT_TESTING:BOOL=ON \
          -DROBOTOLOGY_USES_GAZEBO:BOOL=ON \
          -DROBOTOLOGY_USES_PYTHON:BOOL=ON && \
    make && \
    cd ../.. && rm -Rf robotology-superbuild

# Clean up git configuration
RUN git config --global --unset-all user.name && \
    git config --global --unset-all user.email

# ROS noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - && \
    apt update && apt install -y ros-noetic-desktop-full

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool && \
    rosdep init && rosdep update

WORKDIR /root

RUN pip install gym explauto && \
    git clone https://gitlab.com/pablo_rr/code-icub-gazebo-skin.git && \
    cd code-icub-gazebo-skin/gym-icub-skin && \
    pip install -e . && \
    cd ../gazebo_contactsensor_plugin && \
    mkdir build && \
    cd build && \
    cmake .. && make

RUN echo "export AMENT_PREFIX_PATH=${AMENT_PREFIX_PATH}:/usr/local/share/" >> .bashrc && \
    echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/root/code-icub-gazebo-skin/gazebo_contactsensor_plugin/build" >> .bashrc && \
    echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/root/code-icub-gazebo-skin/gazebo-models" >> .bashrc

# Install informative git for bash
RUN git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1

# Set up .bashrc
RUN echo "alias code='code --user-data-dir=\"/root/.vscode\"'" >> /root/.bashrc && \
    echo "source /etc/profile.d/bash_completion.sh" >> /root/.bashrc && \
    echo "GIT_PROMPT_ONLY_IN_REPO=1" >> /root/.bashrc && \
    echo "source \${HOME}/.bash-git-prompt/gitprompt.sh" >> /root/.bashrc && \
    echo "YARP_COLORED_OUTPUT=1" >> /root/.bashrc && \
    echo "source ${ROBOTOLOGY_SUPERBUILD_INSTALL_DIR}/share/robotology-superbuild/setup.sh" >> /root/.bashrc \
    echo "source /usr/share/gazebo/setup.sh" >> /root/.bashrc

# NEW INSTALLS. MOVE UPPER WHEN FINISH
RUN apt-get update && apt-get install -y gedit nano

WORKDIR /root
RUN git clone https://github.com/pabloreyesrobles/HebbianMetaLearning.git && \
    cd HebbianMetaLearning && git checkout icub-skin && \
    pip install -r requirements.txt

WORKDIR /root
COPY script.sh .
RUN sed -i 's/\r//' script.sh

RUN pip install h5py

#ENTRYPOINT ./script.sh && /bin/bash
SHELL [ "/bin/bash", "-c" ]