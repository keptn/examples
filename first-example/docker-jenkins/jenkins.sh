#! /bin/bash -e

: "${JENKINS_WAR:="/usr/share/jenkins/jenkins.war"}"
: "${JENKINS_HOME:="/var/jenkins_home"}"
touch "${COPY_REFERENCE_FILE_LOG}" || { echo "Can not write to ${COPY_REFERENCE_FILE_LOG}. Wrong volume permissions?"; exit 1; }
echo "--- Copying files at $(date)" >> "$COPY_REFERENCE_FILE_LOG"
find /usr/share/jenkins/ref/ \( -type f -o -type l \) -exec bash -c '. /usr/local/bin/jenkins-support; for arg; do copy_reference_file "$arg"; done' _ {} +

sed -i 's/DOCKER_REGISTRY_URL_PLACEHOLDER/'"$DOCKER_REGISTRY_IP"'/' $JENKINS_HOME/config.xml
sed -i 's/GITHUB_USER_EMAIL_PLACEHOLDER/'"$GITHUB_USER_EMAIL"'/' $JENKINS_HOME/config.xml
sed -i 's/GITHUB_ORGANIZATION_PLACEHOLDER/'"$GITHUB_ORGANIZATION"'/' $JENKINS_HOME/config.xml
sed -i 's/DT_TENANT_URL_PLACEHOLDER/'"$DT_TENANT_URL"'/' $JENKINS_HOME/config.xml
sed -i 's/DT_API_TOKEN_PLACEHOLDER/'"$DT_API_TOKEN"'/' $JENKINS_HOME/config.xml
sed -i 's/DT_TENANT_URL_PLACEHOLDER/'"$DT_TENANT_URL"'/' $JENKINS_HOME/de.tsystems.mms.apm.performancesignature.dynatracesaas.DynatraceGlobalConfiguration.xml

find $JENKINS_HOME/jobs -type f -name 'config.xml' -exec sed -i 's/GITHUB_ORGANIZATION_PLACEHOLDER/'"$GITHUB_ORGANIZATION"'/' {} +

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  # read JAVA_OPTS and JENKINS_OPTS into arrays to avoid need for eval (and associated vulnerabilities)
  java_opts_array=()
  while IFS= read -r -d '' item; do
    java_opts_array+=( "$item" )
  done < <([[ $JAVA_OPTS ]] && xargs printf '%s\0' <<<"$JAVA_OPTS")

  if [[ "$DEBUG" ]] ; then
    java_opts_array+=( \
      '-Xdebug' \
      '-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y' \
    )
  fi

  jenkins_opts_array=( )
  while IFS= read -r -d '' item; do
    jenkins_opts_array+=( "$item" )
  done < <([[ $JENKINS_OPTS ]] && xargs printf '%s\0' <<<"$JENKINS_OPTS")

  exec java -Djenkins.install.runSetupWizard=false -Duser.home="$JENKINS_HOME" "${java_opts_array[@]}" -jar ${JENKINS_WAR} "${jenkins_opts_array[@]}" "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
