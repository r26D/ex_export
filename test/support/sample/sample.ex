defmodule Sample do
  require ExExport
  alias Sample.Actions.Greet

  ExExport.export(Greet)
  ExExport.export(Sample.Actions.Farewell)
  ExExport.export(Sample.Actions.AllButAction,exclude: [all_but_action1: 1])
  ExExport.export(Sample.Actions.OnlySomeAction,only: [some_action1: 1])

end
