defmodule Spiral2 do

  @move %{
    down:       { 0,  1},
    down_left:  {-1,  1},
    down_right: { 1,  1},
    left:       {-1,  0},
    right:      { 1,  0},
    up:         { 0, -1},
    up_left:    {-1, -1},
    up_right:   {-1,  1},
  }

  @turn %{
    down: :right,
    left: :down,
    right: :up,
    up: :left,
  }

  def steps(n) do
    {x, y} = generate(n)[n]
    abs(x) + abs(y)
  end

  def generate(size) when is_number(size) and size >= 1 do
    generate(%{
      current: 1,
      direction: :right,
      last: size,
      ring: 1,
      spiral: %{
        coordinates: %{{0, 0} => 1},
        values: %{1 => {0, 0}},
      },
      steps: 1,
    })
  end

  def generate(%{
    current: last,
    last: last,
    spiral: spiral,
  }) do
    spiral
  end

  def generate(state = %{
    direction: direction,
    ring: ring,
    steps: 0,
  }) do
    direction = @turn[direction]
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
    {mx, my} = @move[direction]
    {px, py} = get_in(spiral, [:values, current - 1])
    {nx, ny} = {px + mx, py + my}
    value = Enum.reduce(@move, 0, fn({_k, {x, y}}, result) ->
      case get_in(spiral, [:coordinates, {nx + x, ny + y}]) do
        nil -> result
        n   -> result + n
      end
    end)
    spiral
    |> put_in([:values, current], {nx, ny})
    |> put_in([:coordinates, {nx, ny}], value)
  end

  defp ring(ring, direction) when direction in [:right, :left], do: ring + 1
  defp ring(ring, _), do: ring
end
