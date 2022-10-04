FROM ubuntu:latest

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
RUN apt-get install -y apt-utils gedit x11-apps sudo

SHELL ["/bin/bash", "-c"] 