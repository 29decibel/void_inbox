# cleaning html
# remove trackers
# remove scripts
defmodule Html.Cleaning do
  def clean(html_string) do
    case html_string |> Floki.parse_document() do
      {:ok, doc} ->
        doc
        |> Floki.filter_out("script")
        |> Floki.filter_out(
          "img[height='1'][width='1'], img[height='1px'][width='1px'], img[style*='height: 1px'][style*='width: 1px']"
        )
        |> Floki.raw_html()

      _ ->
        html_string
    end
  end
end
