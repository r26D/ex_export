defmodule Sample.Actions.ExcludeFromFunction do
  @moduledoc """
    This is used for tests relating to exclude but from a functions
  """
  def exclude_from_function1 do
    "action1"
  end

  def exclude_from_function1(name) do
    "action1 #{name}!"
  end

  def exclude_from_function2(name) do
    "action2 #{name}!"
  end


  
  def exclude_from_function3(name) do
    "action3 #{name}!"
  end


end
