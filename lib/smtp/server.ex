defmodule Smtp.Server do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_) do
    smtp_port = get_smtp_port()
    IO.inspect("Starting SMTP server at port #{smtp_port}")
    session_options = [callbackoptions: [parse: true]]

    :gen_smtp_server.start(Smtp.Handler,
      port: smtp_port,
      sessionoptions: session_options
    )
  end

  defp get_smtp_port do
    Application.get_env(:void_inbox, :smtp_port)
  end
end
