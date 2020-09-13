defmodule Sample.Actions.OnlySomeAction do
  def some_action1() do
    "action1"
  end

  def some_action1(name) do
    "action1 #{name}!"
  end

end
