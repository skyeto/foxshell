defmodule Foxshell.ShellHandler do
  use Sshd.ShellHandler

  def on_shell(_username, _pubkey, ip, port) do
    addr = List.foldr(Tuple.to_list(ip), "", fn x, acc -> Integer.to_string(x) <> "." <> acc end) <> ":" <> Integer.to_string(port)
    Logger.info(">> #{addr} connected PID #{inspect self()}")
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
    :timer.sleep(1000)
    IO.puts("""

    connected...congratulations. you have reached the modermodemet
    """)
    loop(run_state([]))
  end

  def on_connect(_username, ip, port, method) do
    Logger.debug(fn ->
      """
      Incoming SSH shell #{inspect(self())} from #{inspect(ip)}:#{
        inspect(port)
      } using #{inspect(method)}
      """
    end)
  end

  def on_disconnect(_username, ip, port) do
    Logger.debug(fn ->
      "Disconnecting SSH shell from #{inspect(ip)}:#{inspect(port)}"
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
        IO.puts("")
        IO.puts("Byeee! Wanna grab the sauce? GOTO https://github.com/skyeto/foxshell")
        IO.puts("")
        Logger.info("Closed connection")

      {:input, ^input, 'exit\n'} ->
        IO.puts("")
        IO.puts("Byeee! Wanna grab the sauce? GOTO https://github.com/skyeto/foxshell")
        IO.puts("")
        IO.puts("Exiting...")

      {:input, ^input, 'flag\n'} ->
        IO.puts("")
        IO.puts("Heck!? Why would there be a flag??")
        IO.puts("")
        :timer.sleep(750)
        IO.puts("shhh... this is a secret...\nUmt4QlJ6VWhJR2h2YkNjZ2RYQXVMaTUwYUdseklHbHpiaWQwSUdFZ1kzUm1JSGd6Q2c9PQo=")
        IO.puts("")
        loop(%{state | counter: state.counter + 1})

      {:input, ^input, 'about\n'} ->
        IO.puts("---------------------------------------")
        IO.puts("== ABOUT ==")
        IO.puts(">> Who?")
        :timer.sleep(500)
        IO.puts("Well isn't it obvious? A fox!")
        IO.puts("")
        IO.puts("")
        :timer.sleep(500)
        IO.puts(">> Whaa?")
        :timer.sleep(500)
        IO.puts("You heard me.")
        IO.puts("")
        IO.puts("")
        IO.puts("""
        But in all seriousness, a furry doing tech things and
        bikepacking. Pretty cool stuff if ya' ask me, but some
        people have differing opinions (especially about the
        furry part). Why? I have no idea.

        Wanna contact me? For anything except asking for my
        name for the above reason that is. Ping me on twitter
        @skyetothefox or on \
        """ <> <<109, 97, 105, 108, 64>> <> "skyeto.com")
        IO.puts("I'd love to talk! <3")
        IO.puts("")
        IO.puts("---------------------------------------")
        IO.puts("")
        loop(%{state | counter: state.counter + 1})

      {:input, ^input, 'help\n'} ->
        IO.puts("")
        IO.puts("== COMMANDS ==")
        IO.puts("""
        > help (this command)
        > about
        > flag
        > exit
        """)
        IO.puts("")


        loop(%{state | counter: state.counter + 1})
      {:input, ^input, code} ->
        Logger.info(">> #{inspect self()} ran command #{code}")
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
