defmodule Sample.Actions.NotDelegate do

  def not_delegated() do
    "Hello world!"
  end
  def not_delegated(x) do
    "Hello world #{x}!"
  end

  def not_delegated_list(x,y,z) do
    [x,y,z]
  end

end
