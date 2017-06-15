FROM centos:centos7
MAINTAINER The ViaQ Community <community@TBA>

USER 0

ENV HOME=/opt/app-root/src \
  ES_HOST=localhost \
  ES_PORT=9200 \
  ES_SCHEME=https \
  PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
  RUBY_VERSION=2.0 \
  GEM_HOME=/opt/app-root/src \
  FLUENTD_VERSION=0.12.31 \
  FLUENTD_SECURED="-secured"

LABEL io.k8s.description="Watches TBD" \
  io.k8s.display-name="Watches hackisch sidecar" \
  io.openshift.expose-services="9200:http, 9300:http" \
  io.openshift.tags="logging,elk,elasticsearch"

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum install -y --setopt=tsflags=nodocs \
      gcc-c++ \
      ruby \
      ruby-devel \
      libcurl-devel \
      make \
      bc \
      iproute \
      python3 && \
    yum clean all
RUN mkdir -p ${HOME} && \
    gem install -N --conservative --minimal-deps \
      fluentd:${FLUENTD_VERSION} \
      'elasticsearch-transport:<5' \
      'elasticsearch-api:<5' \
      'elasticsearch:<5' \
      'fluent-plugin-elasticsearch:>1.9.2'

ADD fluentd/ ${HOME}/fluentd
ADD fluentd-secured/ ${HOME}/fluentd-secured
ADD kibana/ ${HOME}/kibana
ADD scripts/ ${HOME}/scripts
ADD *.json ${ES_CONF}/

ADD run.sh install.sh ${HOME}/
RUN ${HOME}/install.sh

WORKDIR ${HOME}
#USER 1000
CMD ["sh", "run.sh"]
