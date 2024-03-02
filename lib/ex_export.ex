defmodule ExExport do
  @show_definitions Application.compile_env(:ex_export, :show_definitions, false)

  @moduledoc """
  This module inspects another module for public functions and generates the defdelegate needed to add them to the local modules name space
  """

  @doc """
    require in the module and them call export for each module you want to import.
    The function list automatically filters out functions that start with an underscore

    ## Examples
    defmodule Sample do
      require ExExport
      alias  Sample.Actions.Greet

      ExExport.export(Greet)
      ExExport.export(Sample.Actions.Farewell)

     end
  ## Options
    * `:only` - (since v0.2.0) a list of [function: arity] only matching functions will be delegated
    * `:exclude` - (since v0.2.0) a list of [function: arity]  matching functions will *NOT* be delegated
    * `:expansion` - (since v.0.8.1) :manual or :macro -
           :macro - use Macro.expand. This seems to generate a compile time dependency
           :manual - uses custom code to figure out the alias resolution -which prevents the compile
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

  """

  defmacro export(module, opts \\ []) do
    # DJE - changed to a manual method to remove a compile time dependency
    resolved_module = expand_module(module, __CALLER__, get_keyword(opts, :expansion, :manual))

    only =  resolve_restriction(get_keyword(opts, :only), __ENV__)
    exclude =  resolve_restriction(get_keyword(opts, :exclude), __ENV__)
   
    if exclude && only do
      raise ArgumentError,
            message: ":only and :exclude are mutually exclusive"
    end

    ExExport.output_definition("<<<<< Exporting To #{inspect(__CALLER__.context_modules)}>>>>")

    try do
      resolved_module.__info__(:functions)
      |> Enum.map(
           fn {func, arity} ->
             if not private_func(func) and included(func, arity, only) and
                not_excluded(func, arity, exclude) do
               use_delegate(func, build_args(arity), resolved_module)
             else
               ExExport.output_definition("Skipping #{func}/#{arity}")
             end
           end
         )
    rescue
      e in UndefinedFunctionError ->
        IO.puts(
          "ExExport doesn't support aliasing - you must use the canonical name of the module.
       This prevents the need for a compile time dependency."
        )

        raise e
    end

  end

  def show_definitions?, do: @show_definitions

  def output_definition(msg) do
    case show_definitions?() do
      true -> IO.puts(msg)
      _ -> nil
    end
  end

  def expand_module(module, caller, method \\ :manual)

  def expand_module(module, caller, :macro) do
    Macro.expand(module, caller)
  end

  def expand_module(module, caller, :manual) do
    #   IO.inspect(module, label: "MOdule")
    #  IO.inspect(caller.aliases, label: "Caller Aliaases")
    case module do
      {:__aliases__, _, parts} ->
        resolve_module_name(parts, caller.aliases)

      _ ->
        raise "Don't know how to handle #{inspect(module)}"
    end
  end

  defp find_alias(key, aliases) do
    case Enum.find(
           aliases,
           fn {alias_key, _module} ->
             #  IO.puts("Comparing #{key} to #{alias_key}")
             "Elixir.#{key}" == "#{alias_key}"
           end
         ) do
      nil -> nil
      {_, module} -> module
    end
  end

  defp resolve_module_name(parts, aliases) do
    #  IO.inspect(parts, label: "Parts")
    #  IO.inspect(aliases, label: "Aliases")
    cond do
      Enum.count(aliases) > 0 ->
        [head | rest] = parts

        case find_alias(head, aliases) do
          nil ->
            parts

          result ->
            [
              result
              |> Atom.to_string()
              |> String.split(".")
              |> List.wrap(),
              rest
            ]
            |> List.flatten()
            |> Enum.reject(&is_nil/1)
        end

      true ->
        parts
    end
    |> then(
         fn list ->
           case Enum.at(list, 0) do
             "Elixir" -> list
             :"Elixir" -> list
             _ -> ["Elixir" | parts]
           end
         end
       )
    |> Enum.join(".")
    |> String.to_atom()
  end

  defp get_keyword(list, label, default \\ nil) do
    case Keyword.fetch(list, label) do
      :error -> default
      {:ok, val} -> val
    end
  end

  defp private_func(func) do
    String.at("#{func}", 0) == "_"
  end

  defp included(_func, _arity, nil), do: true

  defp included(func, arity, only) do
    found?(func, arity, only)
  end

  defp not_excluded(_func, _arity, nil), do: true

  defp not_excluded(func, arity, exclude) do
    if found?(func, arity, exclude), do: false, else: true
  end

  defp found?(func, arity, list) do
    result =
      list
      |> Enum.find_index(
           fn {f, a} ->
             f == func and a == arity
           end
         )
      |> is_nil

    !result
  end

  defp build_args(0), do: []

  defp build_args(arity) do
    Enum.to_list(1..arity)
    |> Enum.map(fn idx -> "arg#{idx}" end)
  end

  defp use_delegate(func, args, resolved_module) do
    str_args = Enum.join(args, ",")
    {:ok, func_args} = Code.string_to_quoted("#{func}(#{str_args})")
    output_definition("defdelegate #{func}(#{str_args}), to: #{resolved_module}")

    quote do
      defdelegate unquote(func_args), to: unquote(resolved_module)
    end
  end

  defp resolve_restriction(value, env) do

    cond do
      is_nil(value) -> nil
      is_list(value) -> value
      true ->
        value
        |> Macro.expand(env)
        |> Code.eval_quoted()
        |> then(
             fn {result, _} ->
               result
             end
           )


    end
  end
end
