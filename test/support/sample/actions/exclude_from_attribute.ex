defmodule Sample.Actions.ExcludeFromAttribute do
  @moduledoc """
    This is used for tests relating to exclude   but from an attributes
  """
  def exclude_from_attribute1 do
    "action1"
  end

  def exclude_from_attribute1(name) do
    "action1 #{name}!"
  end

  def exclude_from_attribute2(name) do
    "action2 #{name}!"
  end


  
  def exclude_from_attribute3(name) do
    "action3 #{name}!"
  end


end
