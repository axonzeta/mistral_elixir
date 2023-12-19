defmodule MistralClient.Chat do
  @moduledoc false
  alias MistralClient.Client
  alias MistralClient.Config

  @base_url "/v1/chat/completions"

  def url(), do: @base_url

  def fetch(params, config \\ %Config{}) do
    url()
    |> Client.api_post(params, config)
  end
end
