defmodule BasicData.Array do
  @moduledoc """
  Array data structure for Elixir, wrapping the OTP/Erlang array with Elixir-friendly functions.

  The OTP/Erlang array isn't a true array in the C sense of a fully random access memory block, but it uses a tuple-based implementation that's much more performant for random access than lists.
  """
  defstruct array: []

  @type t :: %__MODULE__{}

  @spec new(list) :: __MODULE__.t()
  def new(list \\ []) do
    # Return an erlang array
    %__MODULE__{array: :array.from_list(list)}
  end

  @spec to_list(__MODULE__.t()) :: list
  def to_list(%__MODULE__{array: array}), do: :array.to_list(array)
end
