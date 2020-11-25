# Pull base image.
FROM node:8-buster

LABEL maintainer="Mumshad Mannambeth" maintainer_email="mmumshad@gmail.com"
LABEL Description="This image is used to start the ansible-playable web server. The image contains a built-in mongodb database, can mount Amazon S3 instance and runs the playable web server on MEAN stack." Version="alpha"

# Reset Root Password
RUN echo "root:P@ssw0rd@123" | chpasswd

# Install Ansible
RUN apt-get update && \
    apt-get install python-pip python-setuptools python-dev build-essential -y

RUN ln -s /usr/lib/python2.7/dist-packages/easy_install.py /usr/local/bin/easy_install
RUN pip install ansible==2.4.3.0 && \
    pip install pyOpenSSL==16.2.0

# -----------------------------------------------------------

# TO fix a bug
RUN mkdir -p /root/.config/configstore && chmod g+rwx /root /root/.config /root/.config/configstore
RUN useradd -u 1003 -d /home/app_user -m -s /bin/bash -p $(echo P@ssw0rd@123 | openssl passwd -1 -stdin) app_user

# Create data directory
RUN mkdir -p /data

RUN chown -R app_user /usr/local && chown -R app_user /home/app_user && chown -R app_user /data

# Install VIM and Openssh-Server
RUN apt-get update && apt-get install -y vim openssh-server

# Permit Root login
RUN sed -i '/PermitRootLogin */cPermitRootLogin yes' /etc/ssh/sshd_config

# Generate SSH Keys
RUN /usr/bin/ssh-keygen -A

# Start Open-ssh server
RUN service ssh start

# Install YAS3FS for mounting AWS Bucket
RUN apt-get update -q && apt-get install -y python-pip fuse \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN pip install yas3fs
RUN sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf # uncomment user_allow_other
RUN chmod a+r /etc/fuse.conf # make it readable by anybody, it is not the default on Ubuntu

# Install NPM dependencies
RUN npm install -g yo@~1.7.1 chalk@^2.0.0 gulp-cli generator-angular-fullstack

# Change user to app_user
USER app_user

RUN mkdir -p /data/web-app
COPY ./package.json /data/web-app
WORKDIR /data/web-app

# Assign permissions to app_user
USER root
RUN chown -R app_user: /data/web-app

# Change user to app_user
USER app_user

# Create empty logs directory
RUN mkdir -p logs

RUN npm install

# Copy all application files
COPY ./ /data/web-app

# Assign permissions to app_user
USER root

RUN gulp build

RUN chown -R app_user: /data/web-app

# Provide execute permissions for startup script
RUN chmod 755 helpers/startup.sh

# Create ansible-projects folder if it doesn't already exist
RUN mkdir -p /opt/ansible-projects

# Start services and start web server
ENTRYPOINT helpers/startup.sh
