defmodule Smtp.Handler do
  require Logger
  @behaviour :gen_smtp_server_session

  def init(hostname, session_count, _address, _options) do
    if session_count > 40 do
      Logger.warning("SMTP server connection limit exceeded")
      {:stop, :normal, ["421", hostname, " is too busy to accept mail right now"]}
    else
      banner = [hostname, " ESMTP"]
      state = %{}
      {:ok, banner, state}
    end
  end

  def handle_DATA(_from, _to, data, state) do
    Logger.info("Received DATA:")

    Smtp.MailParser.parse_email_data(data)
    |> VoidInbox.Letters.create_letter_from_smtp_handler()

    {:ok, "1", state}
  end

  def handle_STARTTLS(state) do
    state
  end

  def handle_EHLO(_hostname, extensions, state) do
    {:ok, extensions, state}
  end

  def handle_HELO(_hostname, state) do
    {:ok, state}
  end

  def handle_MAIL(_from, state) do
    {:ok, state}
  end

  def handle_MAIL_extension(_extension, state) do
    {:ok, state}
  end

  def handle_RCPT(to, state) do
    Logger.info("RCPT to #{to}")
    {:ok, Map.put(state, :to, to)}
  end

  def handle_RCPT_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  def handle_RSET(state) do
    state
  end

  def handle_VRFY(_address, state) do
    {:ok, ~c"252 VRFY disabled by policy, just send some mail", state}
  end

  def handle_other(command, _args, state) do
    {["500 Error: command not recognized : '", command, "'"], state}
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    {:ok, reason, state}
  end
end
