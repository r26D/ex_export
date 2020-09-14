defmodule ExExportTest do
  use ExUnit.Case
  doctest ExExport
  alias Sample.Actions.{
    Farewell,
    Greet,
    AllButAction,
    NotDelegate,
    OnlySomeAction}

  test "Greet in the module" do
    assert Greet.hello() == "Hello world!"
    assert Greet.hello("Bob") == "Hello Bob!"
  end
  test "handle multiple arguments" do
    assert Greet.more_args("me", "myself", "I") == ["me", "myself", "I"]
    assert Sample.more_args("me", "myself", "I") == ["me", "myself", "I"]

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

  test "able to exclude functions from the export" do
    assert AllButAction.all_but_action1() == "action1"
    assert AllButAction.all_but_action1("bob") == "action1 bob!"
    assert AllButAction.all_but_action2("bob") == "action2 bob!"

    assert Sample.all_but_action1() == "action1"

    assert_raise UndefinedFunctionError, fn ->
      Sample.all_but_action1("bob") == "action1 bob!"
    end
    assert Sample.all_but_action2("bob") == "action2 bob!"

  end
  test "able to include only specific functions from the export" do
    assert OnlySomeAction.some_action1() == "action1"
    assert OnlySomeAction.some_action1("bob") == "action1 bob!"


    assert_raise UndefinedFunctionError, fn ->
      Sample.some_action1() == "action1"
    end
    assert Sample.some_action1("bob") == "action1 bob!"

  end
  test "able to  export with a do instead of a defdelegate" do
    assert NotDelegate.not_delegated() == "Hello world!"

    assert NotDelegate.not_delegated("bob") == "Hello world bob!"
    assert NotDelegate.not_delegated_list(1,2,3) == [1,2,3]

    assert Sample.not_delegated() == "Hello world!"
    assert Sample.not_delegated("bob") == "Hello world bob!"
    assert Sample.not_delegated_list(1,2,3) == [1,2,3]

  end
end
