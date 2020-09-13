defmodule Sample do
  require ExExport
  alias  Sample.Actions.Greet

  ExExport.export(Greet)
  ExExport.export(Sample.Actions.Farewell)

end
