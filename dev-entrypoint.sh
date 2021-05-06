export VAULT_ADDR="http://127.0.0.1:8200"

vault server -dev -dev-root-token-id=root -dev-plugin-dir=./plugins -log-level=debug &

process_id=$!
sleep 2

vault secrets enable op-connect

cat > op-connect-config.json <<EOF
{
    "op_connect_host": "${OP_CONNECT_HOST}",
    "op_connect_token": "${OP_CONNECT_TOKEN}"
}
EOF
vault write op-connect/config @op-connect-config.json

wait $process_id



