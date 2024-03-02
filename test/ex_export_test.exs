defmodule ExExportTest do
  use ExUnit.Case
  doctest ExExport

  alias Sample.Actions.{
    AllButAction,
    Farewell,
    Greet,
    NotDelegate,
    OnlySomeAction,
    HasPrivateMethod,
    ExcludeFromFunction,
    OnlyFromFunction
    },
        warn: false

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

  test "able to only functions from the export using an function" do

    assert OnlyFromFunction.only_from_function1("bob") == "action1 bob!"



    assert_raise UndefinedFunctionError, fn ->
      assert      Sample.only_from_function1() == "action1"
    end
    assert_raise UndefinedFunctionError, fn ->
      assert  Sample.only_from_function2("bob") == "actio2 bob!"
    end

  end

  test "able to exclude functions from the export using an function" do
    assert ExcludeFromFunction.exclude_from_function1() == "action1"
    assert ExcludeFromFunction.exclude_from_function1("bob") == "action1 bob!"
    assert ExcludeFromFunction.exclude_from_function2("bob") == "action2 bob!"
    assert ExcludeFromFunction.exclude_from_function3("bob") == "action3 bob!"



    assert_raise UndefinedFunctionError, fn ->
      assert      Sample.exclude_from_function1("Bob") == "action1 Bob"
    end
    assert_raise UndefinedFunctionError, fn ->
      assert  Sample.exclude_from_function2("bob") == "actio2 bob!"
    end

    assert    Sample.exclude_from_function1() == "action1"
    assert Sample.exclude_from_function3("bob") == "action3 bob!"
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
    assert NotDelegate.not_delegated_list(1, 2, 3) == [1, 2, 3]

    assert Sample.not_delegated() == "Hello world!"
    assert Sample.not_delegated("bob") == "Hello world bob!"
    assert Sample.not_delegated_list(1, 2, 3) == [1, 2, 3]
  end

  test "auto filters private methods" do
    assert Sample.public_action() == "public"
    # assert Sample._private_action() == "_private_action"
    # assert Sample.__private_action() == "__private_action"
    assert_raise UndefinedFunctionError, fn ->
      assert      Sample._private_action() == "_private_action"
    end

    assert_raise UndefinedFunctionError, fn ->
      assert Sample.__private_action() == "__private_action"
    end
  end
end
