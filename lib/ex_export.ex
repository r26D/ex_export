defmodule ExExport do
  @moduledoc """
  This module inspects another module for public functions and generates the defdelegate needed to add them to the local modules name space
  """

  require Logger

  @doc """
    require in the module and them call export for each module you want to import.
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
    * `:delegate` - (since v0.3.0) true/false default true - true means that it will use defdelegate - false it
        builds a local function and maps it manually.


  """
  defmacro export(module, opts \\ []) do
    resolved_module = Macro.expand(module, __CALLER__)

    delegate = get_keyword(opts, :delegate, true)
    only = get_keyword(opts, :only)
    exclude = get_keyword(opts, :exclude)

    if exclude && only do
      raise ArgumentError,
        message: ":only and :exclude are mutually exclusive"
    end

    Logger.debug("<<<<< Exporting To #{inspect(__CALLER__.context_modules)}>>>>")

    resolved_module.__info__(:functions)
    |> Enum.map(fn {func, arity} ->
      if included(func, arity, only) && not_excluded(func, arity, exclude) do
        if delegate do
          use_delegate(func, build_args(arity), resolved_module)
        else
          use_def(func, build_args(arity), resolved_module)
        end
      else
        Logger.debug("Skipping #{func}/#{arity}")
      end
    end)
  end

  defp get_keyword(list, label, default \\ nil) do
    case Keyword.fetch(list, label) do
      :error -> default
      {:ok, val} -> val
    end
  end

  defp safe_to_atom(nil), do: nil
  defp safe_to_atom(value) when is_atom(value), do: value

  defp safe_to_atom(value) do
    String.to_existing_atom(value)
  rescue
    ArgumentError -> String.to_atom(value)
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
    Logger.debug("defdelegate #{func}(#{str_args}), to: #{resolved_module}")

    quote do
      defdelegate unquote(func_args), to: unquote(resolved_module)
    end
  end

  defp use_def(func, args, resolved_module) do
    str_args = Enum.join(args, ",")
    Logger.debug("def #{func}(#{str_args}), do: #{resolved_module}.#{func}(#{str_args})")
    {:ok, func_args} = Code.string_to_quoted("#{func}(#{str_args})")

    quote do
      def unquote(func_args), do: unquote(resolved_module).unquote(func_args)
    end
  end
end
