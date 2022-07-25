defmodule BasicData.Queue do
  @moduledoc """
  This is a queue using a double stack implementation via
  native Elixir lists.
  """
  @type t :: %BasicData.Queue{in_stack: list(), out_stack: list()}
  defstruct in_stack: [], out_stack: []

  def new(list \\ []) do
    %__MODULE__{in_stack: [], out_stack: list}
  end

  @spec empty?(__MODULE__.t()) :: boolean
  def empty?(%__MODULE__{in_stack: [], out_stack: []}), do: true
  def empty?(%__MODULE__{}), do: false

  @spec enqueue(__MODULE__.t(), any) :: __MODULE__.t()
  def enqueue(%__MODULE__{in_stack: in_stack} = queue, x) do
    %{queue | in_stack: [x | in_stack]}
  end

  @spec enqueue(__MODULE__.t(), [any]) :: __MODULE__.t()
  def enqueue_list(%__MODULE__{in_stack: in_stack} = queue, list) when is_list(list) do
    %{queue | in_stack: Enum.reverse(list) ++ in_stack}
  end

  @spec dequeue(queue :: __MODULE__.t()) :: {any, __MODULE__.t()}
  def dequeue(%__MODULE__{out_stack: [head | tail]} = queue) do
    {head, %__MODULE__{queue | out_stack: tail}}
  end

  def dequeue(%__MODULE__{in_stack: in_stack}) do
    [head | tail] = Enum.reverse(in_stack)
    {head, %__MODULE__{out_stack: tail}}
  end

  @spec peek(list) :: any
  def peek(%__MODULE__{out_stack: [head | _]}), do: head
  def peek(%__MODULE__{in_stack: in_stack}), do: List.last(in_stack)

  @spec to_list(__MODULE__.t()) :: list
  def to_list(%__MODULE__{} = queue) do
    queue.out_stack ++ Enum.reverse(queue.in_stack)
  end

  defimpl Inspect, for: __MODULE__ do
    import Inspect.Algebra

    @module_name @for |> to_string() |> String.replace(~r(.*\.), "")

    def inspect(queue, opts) do
      concat(["##{@module_name}<", to_doc(@for.to_list(queue), opts), ">"])
    end
  end
end
