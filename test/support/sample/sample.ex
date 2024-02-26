defmodule Sample do
  @moduledoc """
  This is a sample for a top level barrel
  """
  require ExExport
  alias Sample.Actions.Greet, warn: false

 #@exclude_list [exclude_from_attribute1: 1, exclude_from_attribute2: 1]
  def excluded(),do:  [exclude_from_attribute1: 1, exclude_from_attribute2: 1]

  ExExport.export(Greet)
  ExExport.export(Sample.Actions.Farewell)
  ExExport.export(Sample.Actions.AllButAction, exclude: [all_but_action1: 1])
  ExExport.export(Sample.Actions.ExcludeFromAttribute, exclude: excluded())
  ExExport.export(Sample.Actions.OnlySomeAction, only: [some_action1: 1])
  ExExport.export(Sample.Actions.NotDelegate, delegate: false)
  ExExport.export(Sample.Actions.HasPrivateMethod)
end
