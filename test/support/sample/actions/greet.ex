defmodule Sample.Actions.Greet do
  def hello() do
    "Hello world!"
  end

  def hello(name) do
    "Hello #{name}!"
  end

  def more_args(first, second, third) do
    [first, second,third]
  end
end
