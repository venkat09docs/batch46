FROM centos:centos7
LABEL AUTHOR=rnstech
RUN yum update -y
RUN yum install wget net-tools -y
