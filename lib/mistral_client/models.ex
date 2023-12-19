defmodule MistralClient.Models do
  @moduledoc false
  alias MistralClient.Client
  alias MistralClient.Config

  @models_base_url "/v1/models"

  def url(), do: @models_base_url

  def fetch(config \\ %Config{}) do
    url()
    |> Client.api_get(config)
  end

end
