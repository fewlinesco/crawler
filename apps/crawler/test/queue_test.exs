defmodule QueueTest do
  use ExUnit.Case

  test "add: when argument is a list" do
    queue =
      42
      |> Queue.new
      |> Queue.add([24, 7331])

    assert 3 == Queue.length(queue)
  end

  test "add: when argument is a value" do
    queue =
      42
      |> Queue.new
      |> Queue.add(24)

    assert 2 == Queue.length(queue)
  end

  test "add_new: when argument is a list and contains duplicate" do
    queue =
      [42, 1337]
      |> Queue.new
      |> Queue.add_new([1337, 24, 42, 24])

    assert 3 == Queue.length(queue)
  end

  test "add_new: when argument is a value and contains duplicate" do
    queue =
      [42, 1337]
      |> Queue.new
      |> Queue.add_new(1337)
      |> Queue.add_new(24)
      |> Queue.add_new(42)

    assert 3 == Queue.length(queue)
  end

  test "empty?: when queue is empty" do
    assert Queue.empty?(Queue.new())
  end

  test "empty?: when queue is not empty" do
    refute Queue.empty?(Queue.new(42))
  end

  test "length: when queue contains elements" do
    assert 2 == Queue.length(Queue.new([42, 1337]))
  end

  test "length: when queue does not contain any elements" do
    assert 0 == Queue.length(Queue.new([]))
  end

  test "new: without values" do
    assert Queue.empty?(Queue.new)
  end

  test "new: with a value" do
    assert 1 == Queue.length(Queue.new(12))
  end

  test "new: with some values" do
    assert 2 == Queue.length(Queue.new([12, 42]))
  end

  test "remove" do
    queue =
      Queue.new(42)
      |> Queue.add(1337)
      |> Queue.add([24, 7331])

    assert {[42], queue1} = Queue.remove(queue)
    assert 3 == Queue.length(queue1)
    assert {[42, 1337], queue2} = Queue.remove(queue, 2)
    assert 2 == Queue.length(queue2)
    assert {[42, 1337, 24, 7331], queue3} = Queue.remove(queue, 100)
    assert 0 == Queue.length(queue3)
  end
end
