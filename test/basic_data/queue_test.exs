defmodule QueueTest do
  use ExUnit.Case, async: true

  alias BasicData.Queue

  describe "new" do
    test "initializes to struct" do
      assert %Queue{} = Queue.new()
    end

    test "stores the initial list given" do
      assert %Queue{out_stack: [1]} = Queue.new([1])
    end
  end

  describe "empty?/1" do
    test "returns true if empty" do
      assert Queue.new() |> Queue.empty?()
    end

    test "returns false if not empty" do
      refute Queue.new([1, 2]) |> Queue.empty?()
    end
  end

  describe "enqueue" do
    test "adds a number to the queue" do
      assert %{in_stack: [2], out_stack: [1]} = Queue.new([1]) |> Queue.enqueue(2)
    end
  end

  describe "enqueue_list" do
    test "adds a list of numbers to the queue" do
      result =
        Queue.new([1])
        |> Queue.enqueue_list([2, 3])
        |> Queue.to_list()

      assert [1, 2, 3] = result
    end

    test "enqueuing two lists keeps correct order" do
      result =
        Queue.new()
        |> Queue.enqueue_list([1, 2])
        |> Queue.enqueue_list([3, 4])
        |> Queue.to_list()

      assert [1, 2, 3, 4] = result
    end

    test "mix of single and multiple enqueues" do
      result =
        Queue.new()
        |> Queue.enqueue(1)
        |> Queue.enqueue_list([2, 3])
        |> Queue.enqueue(4)
        |> Queue.enqueue_list([5, 6])
        |> Queue.to_list()

      assert [1, 2, 3, 4, 5, 6] = result
    end
  end

  describe "dequeue" do
    test "returns a tuple with the next item and remaining queue" do
      assert {1, %Queue{out_stack: [2]}} = Queue.new([1, 2]) |> Queue.dequeue()
    end

    test "flips the in-stack when the out-stack is empty" do
      queue = %Queue{in_stack: [3, 2, 1], out_stack: []}

      assert {1, new_queue} = Queue.dequeue(queue)

      assert [2, 3] = Queue.to_list(new_queue)
    end

    test "preserves remainder of both stacks" do
      queue = %Queue{in_stack: [4, 3], out_stack: [1, 2]}

      assert {1, new_queue} = Queue.dequeue(queue)

      assert [4, 3] = new_queue.in_stack
      assert [2] = new_queue.out_stack
    end
  end

  describe "peek" do
    test "returns the next item in the queue" do
      assert 1 = Queue.peek(%Queue{in_stack: [1]})
      assert 1 = Queue.peek(%Queue{out_stack: [1]})
    end
  end

  describe "combination test" do
    test "enqueues and dequeues" do
      numbers = Enum.to_list(1..10)

      enqueued_stack =
        numbers
        |> Enum.reduce(
          Queue.new(),
          fn n, queue -> Queue.enqueue(queue, n) end
        )

      {_, dequeued_list} =
        numbers
        |> Enum.reduce(
          {enqueued_stack, []},
          fn _n, {queue, acc} ->
            result = Queue.dequeue(queue)

            {n, new_queue} = result

            {new_queue, acc ++ [n]}
          end
        )

      enqueued_list = Queue.to_list(enqueued_stack)

      assert enqueued_list == dequeued_list

      "Expected enqueued stack #{inspect(enqueued_list)} to equal dequeued stack #{inspect(dequeued_list)}"
    end

    test "dequeues after enqueued_list" do
      q =
        Queue.new()
        |> Queue.enqueue_list([1, 2, 3])
        |> Queue.enqueue(4)
        |> Queue.enqueue_list([5, 6])

      assert {1, q2} = Queue.dequeue(q)
      assert [2, 3, 4, 5, 6] = Queue.to_list(q2)

      assert {2, q3} = Queue.dequeue(q2)
      assert [3, 4, 5, 6] = Queue.to_list(q3)
    end
  end

  describe "inspect" do
    test "returns encapsulated string of contents" do
      q = Queue.new([1, 2, 3])

      assert "#Queue<[1, 2, 3]>" = inspect(q)
    end
  end
end
