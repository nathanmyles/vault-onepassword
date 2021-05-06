FROM vault:1.7.1

RUN apk add wget unzip jq

WORKDIR vault

RUN wget https://github.com/1Password/vault-plugin-secrets-onepassword/releases/download/v1.0.0/vault-plugin-secrets-onepassword_1.0.0_linux_amd64.zip

RUN unzip vault-plugin-secrets-onepassword_1.0.0_linux_amd64.zip

RUN mkdir plugins

RUN cp vault-plugin-secrets-onepassword_v1.0.0 ./plugins/op-connect

COPY config.hcl config.hcl

COPY dev-entrypoint.sh dev-entrypoint.sh

ENTRYPOINT /vault/dev-entrypoint.sh