defmodule Foxshell.Pkauthenticator do
  use Sshd.PublicKeyAuthenticator

  def authenticate(_, _, _) do
    true
  end
end
