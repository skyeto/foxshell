defmodule Foxshell.ShellHandler do
  use Sshd.ShellHandler

  def on_shell(_username, _pubkey, _ip, _port) do
    # Thanks to -Brian Kendig-
    :ok = IO.puts("""
     ____
     \\  /\  |\\/|
      \\/  \\_/ ..__.
       \\__ _\\____/
          \\_\\_\
    """)

    IO.puts("""

    ...connecting...\
    """)
    Cowrie.spinner(fn -> :timer.sleep(1000) end)
    IO.puts("""

    connected...congratulations. you have reached the modermodemet
    """)
    loop(run_state([]))
  end

  def on_connect(username, ip, port, method) do
    Logger.debug(fn ->
      """
      Incoming SSH shell #{inspect(self())} requested for #{username} from #{inspect(ip)}:#{
        inspect(port)
      } using #{inspect(method)}
      """
    end)
  end

  def on_disconnect(username, ip, port) do
    Logger.debug(fn ->
      "Disconnecting SSH shell for #{username} from #{inspect(ip)}:#{inspect(port)}"
    end)
  end

  defp loop(state) do
    self_pid = self()
    counter = state.counter
    prefix = state.prefix

    input = spawn(fn -> io_get(self_pid, prefix, counter) end)
    wait_input(state, input)
  end

  defp wait_input(state, input) do
    receive do
      {:input, ^input, {:error, :interrupted}} ->
        Logger.info("Closed connection")

      {:input, ^input, 'exit\n'} ->
        IO.puts("Exiting...")

      {:input, ^input, 'about\n'} ->
        Cowrie.hr()
        Cowrie.h1("About")
        Cowrie.h2("Who?")
        :timer.sleep(500)
        Cowrie.line("Well isn't it obvious? A fox!")
        Cowrie.br()
        Cowrie.br()
        :timer.sleep(500)
        Cowrie.h2("Whaa?")
        :timer.sleep(500)
        Cowrie.line("You heard me.")
        Cowrie.br()
        Cowrie.br()
        Cowrie.line("""
        But in all seriousness, a furry doing tech things and
        bikepacking. Pretty cool stuff if ya' ask me, but some
        people have differing opinions (especially about the
        furry part). Why? I have no idea.

        Wanna contact me? For anything except asking for my
        name for the above reason that is. Ping me on twitter
        @skyetothefox or on \
        """ <> <<109, 97, 105, 108, 64>> <> "skyeto.com")
        Cowrie.line("I'd love to talk! <3")
        Cowrie.br()
        Cowrie.hr()
        Cowrie.br()
        loop(%{state | counter: state.counter + 1})

      {:input, ^input, 'help\n'} ->
        Cowrie.h1("Commands")
        Cowrie.ul(["about", "exit"])
        Cowrie.br()


        loop(%{state | counter: state.counter + 1})

      {:input, ^input, _code} ->
        IO.puts("Didn't quite catch that, maybe try `help`?")
        IO.puts("")

        loop(%{state | counter: state.counter + 1})

      {:input, ^input, msg} ->
        :ok = Logger.warn("received unknown message: #{inspect(msg)}")
        loop(%{state | counter: state.counter + 1})
    end
  end

  defp run_state(opts) do
    prefix = Keyword.get(opts, :prefix, "shell")

    %{prefix: prefix, counter: 1}
  end

  defp io_get(pid, prefix, counter) do
    prompt = prompt(prefix, counter)
    send(pid, {:input, self(), IO.gets(:stdio, prompt)})
  end

  defp prompt(_prefix, _counter) do
    prompt =
      "╭─ skyeto@home\n╰─"

    prompt <> " "
  end
end
