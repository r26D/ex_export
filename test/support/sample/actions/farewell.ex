defmodule Sample.Actions.Farewell do
  @moduledoc """
    This module is used for testing export

  """
  def goodbye do
    "Goodbye world!"
  end

  def goodbye(name) do
    "Goodbye #{name}!"
  end
end
