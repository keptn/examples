FROM centos:7

RUN yum install -y epel-release && \
  yum install -y unzip \
  which \
  make \
  wget \
  zip \
  bzip2 \
  python-pip

# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN yum -y groupinstall 'Development Tools'
RUN curl -f -o /etc/yum.repos.d/vbatts-bazel-epel-7.repo  https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo && \
  yum install -y bazel

ENV GOLANG_VERSION 1.10.3
RUN wget https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz && \
  rm go${GOLANG_VERSION}.linux-amd64.tar.gz

ENV GLIDE_VERSION v0.13.1
ENV GO15VENDOREXPERIMENT 1
RUN wget https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  tar -xzf glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64 /usr/local/glide && \
  rm glide-$GLIDE_VERSION-linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:/usr/local/glide
ENV PATH $PATH:/usr/local/
ENV GOROOT /usr/local/go
ENV GOPATH=/home/jenkins/go
ENV PATH $PATH:$GOPATH/bin

CMD ["go","version"]