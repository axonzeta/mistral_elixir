# Mistral_Client

Unofficial community-maintained wrapper for Mistral's platform REST APIs

See https://docs.mistral.ai/ for further info on REST endpoints

## Installation
Add ***:mistral_client*** as a dependency in your mix.exs file.

```elixir
def deps do
  [
    {:mistral_client, "~> 0.1.0"}
  ]
end
```

## Configuration
You can configure mistral_client in your mix config.exs (default $project_root/config/config.exs). If you're using Phoenix add the configuration in your config/dev.exs|test.exs|prod.exs files. An example config is:

```elixir
import Config

config :mistral_client,
  # find it at https://console.mistral.ai/users/api-keys/
  api_key: "your-api-key",
  # optional, passed to [HTTPoison.Request](https://hexdocs.pm/httpoison/HTTPoison.Request.html) options
  http_options: [recv_timeout: 30_000],
  api_url: "https://api.mistral.ai/"

```
## Configuration override
Client library configuration can be overwritten in runtime by passing MistralClient.config(api_key: "KEY", http_options: [recv_timeout: 15_000]) as last argument of the function you need to use. For instance if you need to use a different `api_key`, or `http_options` you can simply do:

```elixir
config_override = MistralClient.config( api_key: "test-api-key" ) # this will return a config struct with "test-api-key" as api_key, all the other config are defaulted by the client by using values taken from config.exs, so you don't need to set the defaults manually

# chat with overriden config
MistralClient.chat(
  [
    "model": "mistral-tiny",
    "messages": [
      {
        "role": "user",
        "content": "What is the best French cheese?"
      }
    ]
  ],
  config_override # <--- pass the overriden configuration as last argument of the function
)

# chat with standard config
MistralClient.chat(
  "model": "mistral-tiny",
  "messages": [
    {
      "role": "user",
      "content": "What is the best French cheese?"
    }
  ]
)
```

you can perform a config override in all the functions, note that `params` argument must be passed explicitly as a list in square brackets if the configuration is to be overwritten, as in the example above.

## Usage overview
Get your API key from https://console.mistral.ai/users/api-keys/

### models()
Retrieve the list of available models
### Example request
```elixir
  MistralClient.models()
```
#### Example response
  ```elixir
  {:ok,
    %{
      data: [
        %{
          "created" => 1702997889,
          "id" => "mistral-medium",
          "object" => "model",
          "owned_by" => "mistralai",
          "parent" => nil,
          "permission" => [
            %{
              "allow_create_engine" => false,
              "allow_fine_tuning" => false,
              "allow_logprobs" => false,
              ....
             }
          ],
          "root" => nil
        }
        ....],
      object: "list"
    }
  }
```
See: https://docs.mistral.ai/api#operation/listModels

### chat()
Creates a completion for the chat message

#### Example request
```elixir
MistralClient.chat(
  "model": "mistral-tiny",
  "messages": [
    {
      "role": "user",
      "content": "What is the best French cheese?"
    }
  ]
)
```

#### Example response
```elixir
  {:ok,
    %{
      choices: [
        %{
          "finish_reason" => "stop",
	  "index" => 0,
	  "message" => %{
            "content" => "It's subjective to determine the 'best' French cheese as it depends on personal preferences. Here are some popular and highly regarded French cheeses in various categories:\n\n1. Soft and Bloomy Rind: Brie de Meaux or Brie de Melun, Camembert de Normandie\n2. Hard and Cooked: Comté, Gruyère\n3. Hard and Uncooked: Cheddar-like: Comté, Beaufort, Appenzeller-style: Vacherin Fribourgeois, Alpine-style: Reblochon\n4. Blue Cheese: Roquefort, Fourme d'Ambert\n5. Goat Cheese: Chavignol, Crottin de Chavignol, Sainte-Maure de Touraine\n\nHowever, I would recommend trying a variety of French cheeses to discover your favorite. It's an enjoyable and delicious experience!",
            "role" => "assistant"
          }
        }
     ],
     created: 1702997889,
     id: "cmpl-83f575cf654b4a83b99d342f644db292",
     model: "mistral-tiny",
     object: "chat.completion",
     usage: %{
       "completion_tokens" => 204,
       "prompt_tokens" => 15,
       "total_tokens" => 219
     }
   }
  }
```

See: https://docs.mistral.ai/api#operation/createChatCompletion for the complete list of parameters you can pass to the chat function

### chat() with stream
Creates a completion for the chat message, by default it streams to `self()`, but you can override the configuration by passing a config override to the function with a different `stream_to`  http_options parameter.

#### Example request
```elixir
MistralClient.chat(
  [
    model: "mistral-tiny",
    messages: [
      %{role: "user", content: "What is the best French cheese?"}
    ],
    stream: true
  ],
  MistralClient.config(http_options: %{stream_to: self(), async: :once})
) 
|> Stream.each(fn res ->
  IO.inspect(res)
end)
|> Stream.run()
```

#### Example response
```elixir
  %{
    "choices" => [
      %{"delta" => %{"role" => "assistant"}, "finish_reason" => nil, "index" => 0}
    ],
    "id" => "cmpl-9d2c56da16394e009cafbbde9cb5d725",
    "model" => "mistral-tiny"
  }
  %{
    "choices" => [
      %{
        "delta" => %{
          "content" => "It's subjective to determine the 'best'",
          "role" => nil
        },
        "finish_reason" => nil,
        "index" => 0
      }
    ],
    "created" => 1702999980,
    "id" => "cmpl-9d2c56da16394e009cafbbde9cb5d725",
    "model" => "mistral-tiny",
    "object" => "chat.completion.chunk"
  }
  %{
    "choices" => [
      %{
        "delta" => %{
          "content" => " French cheese as it largely depends on personal preferences. Here are a",
          "role" => nil
        },
        "finish_reason" => nil,
        "index" => 0
      }
    ],
    "created" => 1702999980,
    "id" => "cmpl-9d2c56da16394e009cafbbde9cb5d725",
    "model" => "mistral-tiny",
    "object" => "chat.completion.chunk"
  }
...
```

### embeddings(params)

#### Example request
```elixir
MistralClient.embeddings(
  model: "mistral-embed",
  input: [
    "Embed this sentence.",
    "As well as this one."
  ]
)
```

#### Example response
```elixir
  {:ok,
   %{
    data: [
     %{
       "embedding" => [-0.0165863037109375, 0.07012939453125, 0.031494140625,
        0.013092041015625, 0.020416259765625, 0.00977325439453125,
        0.0256195068359375, 0.0021114349365234375, -0.00867462158203125,
        -0.00876617431640625, -0.039520263671875, 0.058441162109375,
        -0.025390625, 0.00748443603515625, -0.0290679931640625,
        0.040557861328125, 0.05474853515625, 0.0258636474609375,
        0.031890869140625, 0.0230255126953125, -0.056427001953125,
        -0.01617431640625, -0.061248779296875, 0.012115478515625,
        -0.045745849609375, -0.0269622802734375, -0.0079498291015625,
        -0.03778076171875, -0.040008544921875, 8.23974609375e-4,
        0.0242767333984375, -0.02996826171875, 0.0305023193359375,
        -0.0022830963134765625, -0.012237548828125, -0.036163330078125,
        -0.033172607421875, -0.044891357421875, 0.01326751708984375,
        0.0021228790283203125, 0.00978851318359375, -2.1147727966308594e-4,
        -0.0305633544921875, -0.0230865478515625, -0.024932861328125, ...],
       "index" => 0,
       "object" => "embedding"
     },
     %{
       "embedding" => [-0.0234222412109375, 0.039337158203125,
        0.052398681640625, -0.0183868408203125, 0.03399658203125,
        0.003879547119140625, 0.024688720703125, -5.402565002441406e-4,
        -0.0119171142578125, -0.006988525390625, -0.0136260986328125,
        0.041839599609375, -0.0274810791015625, -0.015411376953125,
        -0.041412353515625, 0.0305328369140625, 0.006023406982421875,
        0.001140594482421875, -0.007167816162109375, 0.01085662841796875,
        -0.03668212890625, -0.033111572265625, -0.044586181640625,
        0.020538330078125, -0.0423583984375, -0.03131103515625,
        -0.0119781494140625, -0.048736572265625, -0.0850830078125,
        0.0203857421875, -0.0023899078369140625, -0.0249176025390625,
        0.019500732421875, 0.007068634033203125, 0.0301055908203125,
        -0.041534423828125, -0.0255584716796875, -0.0246429443359375,
        0.022674560546875, -2.760887145996094e-4, -0.015045166015625,
        -0.01788330078125, 0.0146484375, -0.005573272705078125, ...],
       "index" => 1,
       "object" => "embedding"
     }
    ],
    id: "embd-7d921a4410e249b9960195ab6705b255",
    model: "mistral-embed",
    object: "list",
    usage: %{
      "completion_tokens" => 0,
      "prompt_tokens" => 15,
      "total_tokens" => 15
    }
  }}
```
See: https://docs.mistral.ai/api#operation/createEmbedding

## Other
This client library was inspired and contains snippets from https://github.com/mgallo/openai.ex

## License
The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
