FROM jenkins/jenkins:latest

# Install plugins
RUN /usr/local/bin/install-plugins.sh cloudbees-folder \
  antisamy-markup-formatter \
  build-timeout \
  credentials-binding \
  timestamper \
  ws-cleanup \
  ant \
  gradle \
  workflow-aggregator \
  github-organization-folder \
  pipeline-stage-view \
  git \
  ssh-slaves \
  matrix-auth pam-auth ldap \
  email-ext mailer \
  kubernetes \
  github-oauth \
  ansicolor

USER root

COPY configs/ /opt/config

RUN chmod +x /opt/config/scripts/create-user.sh 
RUN chmod +x /opt/config/scripts/token.sh
RUN chmod +x /opt/config/scripts/regex.sh
RUN chmod +x /opt/config/scripts/bootstrap.sh


# Skip the setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/sbin/tini","--","/opt/config/scripts/bootstrap.sh"]
