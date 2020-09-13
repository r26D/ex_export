defmodule ExExport do
  @moduledoc """
  This module inspects another module for public functions and generates the defdelegate needed to add them to the local modules name space
  """

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

  """
  defmacro export(module, opts \\ []) do
    resolved_module = Macro.expand(module, __CALLER__)


    only = case Keyword.fetch(opts, :only) do
      :error -> nil
      {:ok, val} -> val
    end
    exclude = case Keyword.fetch(opts, :exclude) do
      :error -> nil
      {:ok, val} -> val
    end
    if (exclude && only)  do
      raise ArgumentError,
            message: ":only and :exclude are mutually exclusive"
    end
    resolved_module.__info__(:functions)
    |> Enum.map(
         fn {func, arity} ->
           IO.puts("#{func}/#{arity} #{included(func, arity, only)} #{not_excluded(func, arity, exclude)}")

           if included(func, arity, only)
             && not_excluded(func, arity, exclude) do


             args = build_args(arity)
             {:ok, func_args} = Code.string_to_quoted("#{func}(#{args})")
             delegate(func_args, resolved_module)

           else
             IO.puts("Skipping #{func}/#{arity}")
           end
         end
       )
  end
  defp included(_func, _arity, nil), do: true

  defp included(func, arity, only) do
    found?(func, arity, only)
  end

  defp not_excluded(_func, _arity, nil), do: true

  defp not_excluded(func, arity, exclude) do
  if  found?(func, arity, exclude), do: false ,else: true

  end

  defp found?(func,arity,list) do
    result = list
    |> Enum.find_index(
         fn {f, a} ->
           f == func and a == arity
         end
       )|> is_nil
      !result
  end
  defp build_args(0), do: ""
  defp build_args(arity) do
    Enum.to_list(1..arity)
    |> Enum.map(fn _ -> 'arg' end)
    |> Enum.join(",")
  end
  defp delegate(func_args, resolved_module) do
    quote do
      defdelegate unquote(func_args), to: unquote(resolved_module)
    end
  end
end
