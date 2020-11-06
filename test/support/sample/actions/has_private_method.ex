defmodule Sample.Actions.HasPrivateMethod do
  @moduledoc """
    This is used for tests relating to private filtering
  """
  def public_action do
    "public"
  end

  def _private_action do
    "_private_action"
  end

  def __private_action do
    "__private_action"
  end
end
