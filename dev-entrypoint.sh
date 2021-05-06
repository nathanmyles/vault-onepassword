export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_FORMAT="json"

vault server -config=config.hcl &

process_id=$!
sleep 2

vault operator init > /vault/init.json
root_token=$(cat /vault/init.json | jq -r .root_token)
cat /vault/init.json | jq -r .unseal_keys_hex[0] > /vault/unseal_1
cat /vault/init.json | jq -r .unseal_keys_hex[1] > /vault/unseal_2
cat /vault/init.json | jq -r .unseal_keys_hex[2] > /vault/unseal_3
vault operator unseal "$(cat /vault/unseal_1)"
vault operator unseal "$(cat /vault/unseal_2)"
vault operator unseal "$(cat /vault/unseal_3)"
vault login "$root_token"
vault token create -id=root

vault write sys/plugins/catalog/secret/op-connect \
sha_256="$(sha256sum /vault/plugins/op-connect | cut -d " " -f1)" \
command="op-connect"
vault secrets enable op-connect

cat > op-connect-config.json <<EOF
{
    "op_connect_host": "${OP_CONNECT_HOST}",
    "op_connect_token": "${OP_CONNECT_TOKEN}"
}
EOF
vault write op-connect/config @op-connect-config.json

wait $process_id



