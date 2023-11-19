defmodule Smtp.MailParser do
  #  {"multipart", "mixed", headers, _, array_of_multiparts}
  #    {"multipart", "alternative", headers, _, list_of_parts}
  #       {"text", "plain", headers, _, text_string}
  #       {"text", "html", headers, _, body_text}
  #       {"image", "png", headers, _, binary}

  def parse_email_data(data) do
    mime_mail_data = :mimemail.decode(data)

    parse_email(mime_mail_data)
    |> IO.inspect(label: "Parsed email")
  end

  def parse_email(data, body_only \\ false) do
    case data do
      {"multipart", "alternative", headers, _, text_and_html_parts} ->
        if body_only do
          parse_text_html_body(text_and_html_parts)
        else
          %{
            headers: headers |> parse_headers(),
            body: parse_text_html_body(text_and_html_parts)
          }
        end

      {"multipart", "mixed", headers, _, array_of_multi_parts} ->
        %{
          headers: headers |> parse_headers(),
          body: array_of_multi_parts |> List.first() |> parse_email(true)
        }

      {"text", "plain", headers, _, just_text} ->
        %{
          headers: headers |> parse_headers(),
          body: %{
            text: just_text,
            html: ""
          }
        }

      {"text", "html", headers, _, html_body} ->
        %{
          headers: headers |> parse_headers(),
          body: %{
            text: "",
            html: html_body
          }
        }

      other ->
        IO.inspect(other)
        {:error, "Not a valid email"}
    end
  end

  def parse_headers(headers) do
    headers
    |> Enum.filter(fn {name, _v} ->
      Enum.member?(["Subject", "Date", "To", "From", "Message-ID"], name)
    end)
    |> Enum.reduce(%{}, fn {name, value}, acc ->
      case name do
        "From" -> acc |> Map.put(name, parse_from(value))
        _ -> acc |> Map.put(name, value)
      end
    end)
  end

  def parse_text_html_body(text_and_html_parts) when is_list(text_and_html_parts) do
    text =
      text_and_html_parts
      |> Enum.find(fn stuff ->
        case stuff do
          {"text", "plain", _, _, body} when is_binary(body) -> true
          _ -> false
        end
      end)
      |> extract_string_from_parts

    html =
      text_and_html_parts
      |> Enum.find(fn stuff ->
        case stuff do
          {"text", "html", _, _, body} when is_binary(body) -> true
          _ -> false
        end
      end)
      |> extract_string_from_parts

    %{text: text, html: html}
  end

  def parse_from(from_string) when is_binary(from_string) do
    email_regex = ~r/<(.*?)>/

    email =
      case Regex.scan(email_regex, from_string) do
        [[_, matched_email]] -> matched_email
        _ -> from_string
      end

    name = Regex.replace(email_regex, from_string, "") |> String.trim()

    %{
      name: name,
      email: email
    }
  end

  def extract_string_from_parts({_, _, _, _, stuff}), do: stuff
  def extract_string_from_parts(_), do: nil
end
