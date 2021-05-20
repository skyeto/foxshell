defmodule Foxshell.Application do
  use Application

  def start(_, _) do
    children = []
    opts = [strategy: :one_for_one, name: Foxshell.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
