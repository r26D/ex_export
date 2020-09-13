defmodule Sample.Actions.Farewell do
  def goodbye() do
    "Goodbye world!"
  end
  def goodbye(name) do
    "Goodbye #{name}!"
  end
end
