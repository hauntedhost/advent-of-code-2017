defmodule Spiral1 do

  @moves %{
    right: { 1,  0},
    left:  {-1,  0},
    up:    { 0, -1},
    down:  { 0,  1},
  }

  def generate(1) do
    %{1 => {0, 0}}
  end

  def generate(2) do
    1
    |> generate
    |> Map.put(2, {1, 0})
  end

  def generate(size) when is_number(size) and size > 2 do
    generate(%{
      current: 2,
      direction: :up,
      last: size,
      ring: 1,
      spiral: generate(2),
      steps: 1,
    })
  end

  def generate(%{
    current: current,
    last: last,
    spiral: spiral,
  }) when current >= last do
    spiral
  end

  def generate(state = %{
    direction: direction,
    ring: ring,
    steps: 0,
  }) do
    direction = turn(direction)
    generate(%{state |
      direction: direction,
      ring: ring(ring, direction),
      steps: ring(ring, direction),
    })
  end

  def generate(state = %{
    current: current,
    direction: direction,
    ring: ring,
    spiral: spiral,
    steps: steps,
  }) do
    generate(%{state |
      current: current + 1,
      direction: direction,
      ring: ring,
      steps: steps - 1,
      spiral: add(spiral, current + 1, direction),
    })
  end

  defp add(spiral, current, direction) do
    {mx, my} = @moves[direction]
    {x, y} = Map.get(spiral, current - 1)
    Map.put(spiral, current, {x + mx, y + my})
  end

  defp ring(ring, direction) when direction in [:right, :left], do: ring + 1
  defp ring(ring, _), do: ring

  defp turn(:right), do: :up
  defp turn(:up),    do: :left
  defp turn(:left),  do: :down
  defp turn(:down),  do: :right
end
