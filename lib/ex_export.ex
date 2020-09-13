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


  """
  defmacro export(module) do
    resolved = Macro.expand(module, __CALLER__)

    resolved.__info__(:functions)
    |> Enum.map(
         fn ({func, arity}) ->
           args = if arity == 0 do
             ""
           else
             Enum.to_list(1..arity)
             |> Enum.map(fn _ -> 'arg' end)
             |> Enum.join(",")
           end
           {:ok, func_args} = Code.string_to_quoted("#{func}(#{args})")
           quote do
             defdelegate unquote(func_args), to: unquote(resolved)
           end
         end
       )
  end
end
