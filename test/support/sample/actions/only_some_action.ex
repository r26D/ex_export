defmodule Sample.Actions.OnlySomeAction do
  @moduledoc """
    This is used for tests relating to only
  """
  def some_action1 do
    "action1"
  end

  def some_action1(name) do
    "action1 #{name}!"
  end
end
