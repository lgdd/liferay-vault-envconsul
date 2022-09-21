FROM liferay/dxp:7.4.13-u42

# Allow to change envconsul version with different image builds.
ARG ENVCONSUL_VERSION=0.13.0

# As a non-root user, we're keeping enconsul binary under our application folder.
RUN curl -o /opt/liferay/envconsul.zip https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
  unzip /opt/liferay/envconsul.zip -d /opt/liferay/envconsul && \
  rm /opt/liferay/envconsul.zip

# Make sure we can execute envconsul binary as a command.
ENV PATH=$PATH:/opt/liferay/envconsul

# We can keep our parameters in a configuration file.
# https://github.com/hashicorp/envconsul#configuration-file
COPY config.hcl /opt/liferay/envconsul/config.hcl

# We keep the default entrypoint structure from Liferay Docker image (https://github.com/liferay/liferay-docker/blob/2367063642f1c98b707f008708a29061a3e87527/templates/bundle/Dockerfile#L23)
# which uses Tini to spawn a single child process (https://github.com/krallin/tini#readme).
#
# The main goal of this PoC resides here:
# run Envconsul to get Vault's secrets and start our Liferay process
# which will inherit our secrets as environment variables not visible system wide.
ENTRYPOINT tini -- envconsul -config "/opt/liferay/envconsul/config.hcl" -vault-addr="${VAULT_ADDR}" /usr/local/bin/liferay_entrypoint.sh

# You could run Envconsul without a configuration file with inline parameters.
# ENTRYPOINT tini -- envconsul -no-prefix=true -upcase -vault-renew-token=false -vault-addr="${VAULT_ADDR}" -secret="secret/liferay" /usr/local/bin/liferay_entrypoint.sh