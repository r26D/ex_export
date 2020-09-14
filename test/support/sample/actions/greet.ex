defmodule Sample.Actions.Greet do
  @moduledoc """
    This module is used to verify that functions are exportable
  """
  def hello do
    "Hello world!"
  end

  def hello(name) do
    "Hello #{name}!"
  end

  def more_args(first, second, third) do
    [first, second, third]
  end
end
