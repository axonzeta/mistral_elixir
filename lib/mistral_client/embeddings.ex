defmodule MistralClient.Embeddings do
  @moduledoc false
  alias MistralClient.Client
  alias MistralClient.Config

  @embeddings_base_url "/v1/embeddings"

  def url(), do: @embeddings_base_url

  def fetch(params, config \\ %Config{}) do
    url()
    |> Client.api_post(params, config)
  end
end
