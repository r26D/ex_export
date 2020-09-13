# ExExport

I have grown used to having a lot of little files that get bundled up into a library (blame my time working
in node/ES6 land).  Because of the compiled nature of Elixir it seemed like this style of file structure
should work without run time penalties.  

This directive is an experiment to enable that. It allows me to build API barrels the same way I do in
Javascript.

/lib
   api.ex
   actions/
       welcome.ex
       farewell.ex
       
       
```elixir
#api.ex
defmodule API do
  require ExExport
  alias API.Actions.Welcome
  ExExport.export(Welcome)
  ExExport.export(API.Actions.Farewell)

end      
```

This adds defdelegate for all public methods in the referenced files.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_export` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_export, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_export](https://hexdocs.pm/ex_export).

