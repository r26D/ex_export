defmodule Sample.Actions.Greet do
  def hello() do
    "Hello world!"
  end
  def hello(name) do
    "Hello #{name}!"
  end
end
