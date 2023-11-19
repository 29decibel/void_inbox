defmodule StoicQuotes do
  def random_quotes do
    # read from priv/static
    File.read!("priv/static/stoic_quotes.json")
    |> Jason.decode!()
    |> Enum.flat_map(fn {author, quotes} ->
      Enum.map(quotes, fn quote ->
        {author, quote}
      end)
    end)
    |> Enum.random()
  end
end
