FROM openjdk:8-jre-slim
MAINTAINER Sonny Yu <sonnyyu123@gmail.com>
ENV USER burpsuite
ENV HOME /home/${USER}
ENV VERSION 2022.3.1
ENV PORTS 8080
ENV DEBIAN_FRONTEND noninteractive
ENV APP https://portswigger.net/burp/releases/download?product=community&version=${VERSION}&type=Jar

RUN echo -e '\033[36;1m ******* INSTALL PACKAGES ******** \033[0m' && \
  apt-get update && apt-get install --no-install-recommends -y \
  sudo \
  software-properties-common \
  fonts-dejavu \
  wget \
  openssl \
  libxext6 \
  libxrender1 \
  libxtst6 \
  libxi6 \
  font-manager \
  libfreetype6 && \
  rm -rf /var/lib/apt/lists/*

RUN echo -e '\033[36;1m ******* ADD USER ******** \033[0m' && \
  useradd -d ${HOME} -m ${USER} && \
  passwd -d ${USER} && \
  adduser ${USER} sudo

RUN echo -e '\033[36;1m ******* SELECT USER ******** \033[0m'
USER ${USER}

RUN echo -e '\033[36;1m ******* SELECT WORKING SPACE ******** \033[0m'
WORKDIR ${HOME}

RUN echo -e '\033[36;1m ******* INSTALL APP ******** \033[0m' && \
  sudo mkdir /burp && \
  sudo chown -R ${USER}:${USER} /burp && \
  wget -q -O /burp/burpsuite.jar ${APP} && \
  mkdir -p ${HOME}/.java/.userPrefs/burp/ &&  \
  sudo apt-get --purge autoremove -y wget

RUN echo -e '\033[36;1m ******* ADD USER TO GROUP ******** \033[0m' && \
  sudo addgroup burp && \
  sudo adduser ${USER} burp
  
RUN echo -e '\033[36;1m ******* OPENING PORTS ******** \033[0m'
EXPOSE ${PORTS}

RUN echo -e '\033[36;1m ******* CONTAINER START COMMAND ******** \033[0m'
CMD java -jar /burp/burpsuite.jar
