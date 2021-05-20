defmodule Foxshell.ShellAuthenticator do
  use Sshd.PasswordAuthenticator

  def authenticate(_username, _password) do
    true
  end
end
