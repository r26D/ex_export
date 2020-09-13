defmodule ExExportTest do
  use ExUnit.Case
  doctest ExExport
  alias Sample.Actions.Farewell
  alias Sample.Actions.Greet

  test "Greet in the module" do
    assert Greet.hello() == "Hello world!"
  end

  test "Farewell in the module" do
    assert Farewell.goodbye() == "Goodbye world!"
  end

  test "greets the world" do
    assert ExExport.hello() == :world
  end
end
