# SMTP.Simulate.send_email()
defmodule SMTP.Simulate do
  def ok_mail do
    from = "me@notyou.com"
    to = ["you@voidinbox.app"]

    # Format the date according to RFC 2822
    date = Timex.format!(Timex.now(), "%a, %d %b %Y %T %z", :strftime)

    # Include the Date header in the email body
    body = """
    To: you@notme.com\r\nSubject: Hello, world!\r\nFrom: me@notyou.com\r\nDate: #{date}\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nNice to meet you
    """

    message = {from, to, body |> String.trim()}

    :gen_smtp_client.send_blocking(message, smtp_config())
  end

  def bad_mail do
    from = "me@notyou.com"
    to = ["you@voidinbox.app"]

    # Include the Date header in the email body
    body = """
    To: you@notme.com\r\nSubject: Hello, world!\r\nFrom: me@notyou.com\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nNice to meet you
    """

    message = {from, to, body |> String.trim()}

    :gen_smtp_client.send_blocking(message, smtp_config())
  end

  defp smtp_config do
    [
      relay: "localhost",
      port: Application.get_env(:void_inbox, :smtp_port)
    ]
  end
end
