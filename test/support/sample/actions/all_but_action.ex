defmodule Sample.Actions.AllButAction do
  @moduledoc """
    This is used for tests relating to exclude
  """
  def all_but_action1 do
    "action1"
  end

  def all_but_action1(name) do
    "action1 #{name}!"
  end

  def all_but_action2(name) do
    "action2 #{name}!"
  end

  def all_but_action3(name) do
    "action3 #{name}!"
  end
  
end
