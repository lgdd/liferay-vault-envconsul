FROM liferay/dxp:7.4.13-u42

ARG ENVCONSUL_VERSION=0.13.0

RUN curl -o /opt/liferay/envconsul.zip https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
  unzip /opt/liferay/envconsul.zip -d /opt/liferay/envconsul && \
  rm /opt/liferay/envconsul.zip

ENV PATH=$PATH:/opt/liferay/envconsul

ENTRYPOINT tini -- envconsul -no-prefix=true -upcase -vault-renew-token=false -vault-addr="${VAULT_ADDR}" -secret="secret/liferay" /usr/local/bin/liferay_entrypoint.sh