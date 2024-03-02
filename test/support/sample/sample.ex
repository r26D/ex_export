defmodule Sample.Defs do
  @moduledoc """
  This module has to be compiled first so that the function is available in the module scope.
  """
  def exclude_list(), do: [exclude_from_function1: 1, exclude_from_function2: 1]
  def only_list(), do: [only_from_function1: 1]
end

defmodule Sample do
  @moduledoc """
  This is a sample for a top level barrel
  """
  alias Sample.Defs, warn: false
  require ExExport

  alias Sample.Actions.Greet, warn: false

  ExExport.export(Greet)
  ExExport.export(Sample.Actions.Farewell)

  ExExport.export(
    Sample.Actions.AllButAction,
    exclude: [
      all_but_action1: 1
    ]
  )
  ExExport.export(Sample.Actions.ExcludeFromFunction, exclude: Defs.exclude_list())
  ExExport.export(
    Sample.Actions.OnlySomeAction,
    only: [
      some_action1: 1
    ]
  )
  ExExport.export(Sample.Actions.OnlyFromFunction, only: Defs.only_list())
  ExExport.export(Sample.Actions.NotDelegate, delegate: false)
  ExExport.export(Sample.Actions.HasPrivateMethod)
end
