FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y git curl gosu && rm -rf /var/lib/apt/lists/*
RUN echo "building jenkins!"
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN mkdir -p $JENKINS_HOME/jobs \
  && chown ${uid}:${gid} $JENKINS_HOME/jobs 

RUN mkdir -p $JENKINS_HOME/workspaces \
  && chown ${uid}:${gid} $JENKINS_HOME/workspaces 


# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Use tini as subreaper in Docker container to adopt zombie processes
ARG TINI_VERSION=v0.16.1
COPY tini_pub.gpg ${JENKINS_HOME}/tini_pub.gpg
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture) -o /sbin/tini \
  && curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture).asc -o /sbin/tini.asc \
  && gpg --no-tty --import ${JENKINS_HOME}/tini_pub.gpg \
  && gpg --no-tty --verify /sbin/tini.asc \
  && rm -rf /sbin/tini.asc /root/.gnupg \
  && chmod +x /sbin/tini

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.138.1}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=ecb84b6575e86957b902cce5e68e360e6b0768b0921baa405e61d314239e5b27

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh

RUN chmod +x /usr/local/bin/jenkins.sh

COPY /configs/jenkins_home_config.xml "$JENKINS_HOME"/config.xml
COPY /configs/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml "$JENKINS_HOME"/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml
COPY /configs/de.tsystems.mms.apm.performancesignature.dynatracesaas.DynatraceGlobalConfiguration.xml "$JENKINS_HOME"/de.tsystems.mms.apm.performancesignature.dynatracesaas.DynatraceGlobalConfiguration.xml
COPY /configs/io.fabric8.jenkins.openshiftsync.GlobalPluginConfiguration.xml "$JENKINS_HOME"/io.fabric8.jenkins.openshiftsync.GlobalPluginConfiguration.xml

ADD /configs/jobs /tmp/jobs
ADD /configs/users "$JENKINS_HOME"/users

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN chmod 755 /usr/local/bin/install-plugins.sh

RUN /usr/local/bin/install-plugins.sh \
kubernetes:1.12.6 \
kubernetes-credentials-provider:0.10 \
workflow-job:2.31 \
workflow-aggregator:2.6 \
credentials-binding:1.16 \
git:3.9.1 \
google-oauth-plugin:0.6 \
google-source-plugin:0.3 \
performance:3.12 \
performance-signature-dynatracesaas:3.0.1 \
performance-signature-ui:3.0.1 \
performance-signature-viewer:3.0.1 \
github-branch-source:2.4.0 \
openshift-sync:1.0.31

RUN cp -R /tmp/jobs/* "$JENKINS_HOME"/jobs/
RUN chown -R ${user} "$JENKINS_HOME"
RUN chmod -R 777 "$JENKINS_HOME"
RUN chmod -R 777 /root

COPY tini-shim.sh /bin/tini
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]