FROM centos:7
MAINTAINER Alan Sherman

RUN yum update -y \
  && yum install -y java-1.8.0-openjdk \
     java-1.8.0-openjdk-devel \
     maven \
     ruby-devel \
     gcc \
     make \
     rpm-build \
     git \
  && yum clean all

RUN gem install --no-ri --no-rdoc fpm

RUN mkdir -p /etc/maven/
COPY settings_new /etc/maven/settings.xml
