defmodule RandomStringGenerator do
  def random_friendly_string() do
    # :crypto.strong_rand_bytes(10) |> Base.encode64()
    for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
  end
end
