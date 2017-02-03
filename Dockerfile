FROM centos:7
MAINTAINER Alan Sherman

RUN yum update -y \
  && yum install -y java-1.8.0-openjdk \
     java-1.8.0-openjdk-devel \
     maven \
  && yum clean all

RUN mkdir -p /etc/maven/
COPY settings_old /etc/maven/settings.xml
