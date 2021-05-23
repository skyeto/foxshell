import Config

config :esshd,
  enabled: true,
  handler: {Foxshell.ShellHandler, :on_shell, 4},
  port: 1234,
  priv_dir: "./priv",
  password_authenticator: Foxshell.ShellAuthenticator,
  access_list: Foxshell.AccessList,
  public_key_authenticator: Foxshell.Pkauthenticator
