defmodule MistralClientTest do
  use ExUnit.Case
  doctest MistralClient

  setup do
    [
      api_key: "123456789"
    ]
  end

end
