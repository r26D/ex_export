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
  ExcludeFromAttribute
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

  test "able to exclude functions from the export using an attribute" do
    assert ExcludeFromAttribute.exclude_from_attribute1() == "action1"
    assert ExcludeFromAttribute.exclude_from_attribute1("bob") == "action1 bob!"
    assert ExcludeFromAttribute.exclude_from_attribute2("bob") == "action2 bob!"
    assert ExcludeFromAttribute.exclude_from_attribute3("bob") == "action3 bob!"

    IO.inspect(Sample.__info__(:functions))

    assert_raise UndefinedFunctionError, fn ->
      Sample.exclude_from_attribute1("bob") == "action1 bob!"
    end
    assert_raise UndefinedFunctionError, fn ->
      Sample.exclude_from_attribute2("bob") == "actio2 bob!"
    end
    assert_raise UndefinedFunctionError, fn ->
      assert Sample.exclude_from_attribute3() == "action3"
    end
    Sample.exclude_from_attribute1() == "action1"
    assert Sample.exclude_from_attribute3("bob") == "action3 bob!"
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
      Sample._private_action() == "_private_action"
    end

    assert_raise UndefinedFunctionError, fn ->
      Sample.__private_action() == "__private_action"
    end
  end
end
