defmodule ExExportTest do
  use ExUnit.Case
  doctest ExExport
  alias Sample.Actions.Farewell
  alias Sample.Actions.Greet

  test "Greet in the module" do
    assert Greet.hello() == "Hello world!"
    assert Greet.hello("Bob") == "Hello Bob!"
  end

  test "Farewell in the module" do
    assert Farewell.goodbye() == "Goodbye world!"
    assert Farewell.goodbye("Bob") == "Goodbye Bob!"
  end

  test "Uses the hello from the Greet module" do
    assert Sample.hello() == "Hello world!"
    assert Sample.hello("Bob") == "Hello Bob!"
  end

  test "uses the goodbye from the Farewell module" do
    assert Sample.goodbye() == "Goodbye world!"
    assert Sample.goodbye("Bob") == "Goodbye Bob!"
  end
end
