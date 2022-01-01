
FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    apt-get -y install sudo

FROM base AS kc
ARG TAGS
RUN adduser --disabled-password --gecos '' kcaverly
RUN adduser kcaverly sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER kcaverly
ENV USER=kcaverly
WORKDIR /home/kcaverly

FROM kc
COPY . denv/
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
