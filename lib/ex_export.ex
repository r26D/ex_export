defmodule ExExport do
  @show_definitions Application.get_env(:ex_export, :show_definitions, false)

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
    resolved_module = Macro.expand(module, __CALLER__)
    only = get_keyword(opts, :only)
    exclude = get_keyword(opts, :exclude)

    if exclude && only do
      raise ArgumentError,
        message: ":only and :exclude are mutually exclusive"
    end

    ExExport.output_definition("<<<<< Exporting To #{inspect(__CALLER__.context_modules)}>>>>")

    resolved_module.__info__(:functions)
    |> Enum.map(fn {func, arity} ->
      if not private_func(func) and included(func, arity, only) and
           not_excluded(func, arity, exclude) do
          use_delegate(func, build_args(arity), resolved_module)
      else
        ExExport.output_definition("Skipping #{func}/#{arity}")
      end
    end)
  end

  def show_definitions?, do: @show_definitions

  def output_definition(msg) do
    case show_definitions?() do
      true -> IO.puts(msg)
      _ -> nil
    end
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
      |> Enum.find_index(fn {f, a} ->
        f == func and a == arity
      end)
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


end
