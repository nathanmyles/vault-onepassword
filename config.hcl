backend "inmem" {}

listener "tcp" {
  address       = "0.0.0.0:8200"

  tls_disable   = true
}

api_addr = "http://0.0.0.0:8200"

plugin_directory = "plugins"
