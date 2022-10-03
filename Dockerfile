FROM ubuntu:22.04

# setup timezone
RUN echo 'America/Santiago' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/America/Santiago /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update

# Install essentials
RUN apt-get install -y apt-utils software-properties-common apt-transport-https sudo \
    psmisc tmux nano wget curl gedit gdb git gitk autoconf locales gdebi \
    meld dos2unix

# Set the locale
RUN locale-gen en_US.UTF-8

RUN apt-get update && apt-get install -y firefox
CMD ["/usr/bin/firefox"]