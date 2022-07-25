defmodule BasicData.BinaryTree do
  @moduledoc """
  This module implements a basic binary tree.

  Use #{__MODULE__}.new() to create a new tree, or pass a list to initialize it.
  """

  defstruct value: nil, left: nil, right: nil

  alias BasicData.Queue

  @doc """
  Creates a new BinaryTree from a list
  """

  def new(list, index \\ 0)

  def new([], _), do: nil

  def new([root], _), do: %__MODULE__{value: root}

  def new(list, index) when index >= length(list), do: nil

  def new(list, index) do
    case list |> Enum.at(index) do
      nil ->
        nil

      value ->
        left_child = __MODULE__.new(list, index * 2 + 1)
        right_child = __MODULE__.new(list, index * 2 + 2)

        %__MODULE__{value: value, left: left_child, right: right_child}
    end
  end

  @doc """
  Convert a BinaryTree into a list
  """
  def to_list(nil), do: []

  def to_list(%__MODULE__{value: value, right: nil, left: nil}), do: [value]

  def to_list(%__MODULE__{value: value, left: left, right: right}) do
    [value] ++ __MODULE__.to_list(left) ++ __MODULE__.to_list(right)
  end

  @doc """
  Uses a breadth-first-search to return a list of nodes
  """
  def bfs(%__MODULE__{} = tree) do
    Stream.unfold([tree], fn
      [] ->
        nil

      [current | list] ->
        new_elements = for t <- [current.left, current.right], t, do: t

        new_list = list ++ new_elements

        {current.value, new_list}
    end)
    |> Enum.to_list()
  end

  @doc """
  Uses a breadth-first-search to return a list of nodes

  V2: Adding numbers to the head of the list instead of end
  """
  def bfs2(%__MODULE__{} = tree) do
    Stream.unfold([tree], fn
      [] ->
        nil

      list ->
        {current, rest} = List.pop_at(list, -1)

        new_elements = for t <- [current.right, current.left], t, do: t

        new_list = new_elements ++ rest

        {current.value, new_list}
    end)
    |> Enum.to_list()
  end

  @doc """
  Uses a breadth-first-search to return a list of nodes

  V3: Using a Queue
  """
  def bfs3(%__MODULE__{} = tree) do
    [tree]
    |> Queue.new()
    |> Stream.unfold(fn queue ->
      if Queue.empty?(queue) do
        nil
      else
        {current, rest} = Queue.dequeue(queue)

        new_elements = for t <- [current.left, current.right], t, do: t

        new_queue = Queue.enqueue_list(rest, new_elements)

        {current.value, new_queue}
      end
    end)
    |> Enum.to_list()
  end
end
