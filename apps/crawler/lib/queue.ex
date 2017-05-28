defmodule Queue do
  def add(queue, values) when is_list(values) do
    Enum.reduce(values, queue, &(add(&2, &1)))
  end
  def add(queue, value) do
    :queue.in(value, queue)
  end

  def add_new(queue, values) when is_list(values) do
    Enum.reduce(values, queue, &(add_new(&2, &1)))
  end
  def add_new(queue, value) do
    if :queue.member(value, queue) do
      queue
    else
      add(queue, value)
    end
  end

  def empty?(queue) do
    :queue.is_empty(queue)
  end

  def length(queue) do
    :queue.len(queue)
  end

  def new(values \\ []) do
    add(:queue.new, values)
  end

  def remove(queue, length \\ 1) do
    1..length
    |> Enum.reduce({[], queue}, fn _, {values, queue} ->
      {new_values, new_queue} = do_remove(queue)

      {Enum.concat(values, new_values), new_queue}
    end)
  end

  defp do_remove(queue) do
    case :queue.out(queue) do
      {:empty, queue} ->
        {[], queue}
      {{:value, value}, queue} ->
        {[value], queue}
    end
  end
end
