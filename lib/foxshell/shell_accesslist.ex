defmodule Foxshell.AccessList do
  use Sshd.AccessList

  def permit?(_peer_address) do
    true
  end
end
