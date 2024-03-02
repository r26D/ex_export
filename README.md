# ExExport

 This library provides an easy way to make barrel files in Elixir.

      A barrel is a way to rollup exports from several modules into a single convenient module.
      The barrel itself is a module file that re-exports selected exports of other modules.
    
 Source: [Barasat Gitbooks](https://basarat.gitbook.io/typescript/main-1/barrel)

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
defmodule Api.Defs do
  @moduledoc """
  This module has to be compiled first so that the function is available in the module scope.
  """
  def exclude_list(), do: [exclude_from_function1: 1, exclude_from_function2: 1]
  def only_list(), do: [only_from_function1: 1, only_from_function2: 1]
end

defmodule API do
  require ExExport
  alias API.Actions.Welcome
  ExExport.export(Welcome)
  ExExport.export(API.Actions.Farewell)
  ExExport.export(API.Actions.AllButActionFromFunction,exclude: Api.Defs.exclude_list())
  ExExport.export(API.Actions.AllButAction,exclude: [all_but_action1: 1])
  ExExport.export(API.Actions.OnlySomeAction,only: [some_action1: 1])
  ExExport.export(API.Actions.OnlySomeActionFromFunction,only: Api.Defs.only_list())

end      
```

This adds defdelegate for all public methods in the referenced files. It filters out
any methods that start with an underscore so that a method called _app_name or __info__  would be auto excluded.

## :only
This option allows you to set a list of specific functions/arity to include.
If you define a function in a separate module you can use that to generate the list of
function/arity that will be used.

## :exclude
This includes all public functions except the ones matching the list of function/arity
If you define a function in a separate module you can use that to generate the list of
function/arity that will be used.

## :expansion
This can be :manual or :macro. Default is :manual

* :macro - use Macro.expand. This seems to generate a compile time dependency
* :manual - uses custom code to figure out the alias resolution -which prevents the compile
time dependency but can generate a **warning - alias is unused** because we are resolving it. You
can get rid of the warning by changing to :macro, undoing the alias or adding warn: false to the alias


## See the Output
In the configuration file for the environment you wish to render the
data attributes, you can set the `show_definitions`  to true. This
will output the code that is being injected in a readable form. This can be useful
if you get warnings like (Cannot match because already defined)

```elixir
config :ex_export, :show_definitions, true
  ```


## Installation

The package can be installed by adding `ex_export` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_export, "~> 0.8.2"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_export](https://hexdocs.pm/ex_export).

