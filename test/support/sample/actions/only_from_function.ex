defmodule Sample.Actions.OnlyFromFunction do
  @moduledoc """
    This is used for tests relating to only but from afunctions
  """
  def only_from_function1 do
    "action1"
  end

  def only_from_function1(name) do
    "action1 #{name}!"
  end

  def only_from_function2(name) do
    "action2 #{name}!"
  end




end
