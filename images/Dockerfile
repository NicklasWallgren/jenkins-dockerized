FROM jenkins:latest

MAINTAINER Nicklas Wallgren <nicklas.wallgren@gmail.com>

# Arguments
ARG DEFAULT_USER=root
ARG JENKINS_PLUGINS=NULL

# Set the working directory
WORKDIR /var/jenkins_home

# Default user, configurable
USER ${DEFAULT_USER}

##########################################
#                                        #
# Install docker                         #
#                                        #
##########################################
RUN apt-get update && apt-get install -y --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install -y docker-ce

##########################################
#                                        #
# Install Jenkins plugins                #
#                                        #
##########################################

RUN for i in ${JENKINS_PLUGINS}; do \
  install-plugins.sh $i; \
done;