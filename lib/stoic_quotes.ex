defmodule StoicQuotes do
  def random_quotes do
    # read from priv/static
    :code.priv_dir(:void_inbox)
    |> Path.join("static/stoic_quotes.json")
    |> File.read!()
    |> Jason.decode!()
    |> Enum.flat_map(fn {author, quotes} ->
      Enum.map(quotes, fn quote ->
        {author, quote}
      end)
    end)
    |> Enum.random()
  end
end
