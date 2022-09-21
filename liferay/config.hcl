# https://github.com/hashicorp/envconsul#configuration-file

# We force uppercase for the keys since they're exepcted uppercased.
upcase = true

secret {
  # We don't want to prefix the keys with their parent "folder".
  no_prefix = true
  path = "secret/liferay"
}

vault {
  # No renew in dev mode.
  renew_token = false
}