defmodule Circus1 do
  # http://adventofcode.com/2017/day/7

  defmodule Node do
    defstruct [:pid, :name, :weight, :parent_pid, :children]
  end

  def parse_nodes(input) when is_binary(input) do
    input
    |> parse
    |> Stream.map(&create_node/1)
    |> Stream.into(%{}, fn(node) ->
      {node.pid, node}
    end)
  end

  def create_node(%{"name" => _} = attrs, parent_pid \\ nil) do
    {:ok, pid} = Agent.start_link(fn -> %Node{} end)
    Agent.update(pid, fn(node) ->
      Map.merge(node, %{
        pid: pid,
        parent_pid: parent_pid,
        name: attrs["name"],
        weight: attrs["weight"],
        children: Enum.map(attrs["children"], fn(child_name) ->
          create_node(%{"name" => child_name, "children" => []}, parent_pid)
        end),
      })
    end)
    Agent.get(pid, &(&1))
  end

  def parse(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    ~r/(?<name>\w+)\s+\((?<weight>\d+)\)(\s+->\s+(?<children>.+)|.*)/
    |> Regex.named_captures(line)
    |> Map.update("weight", nil, &String.to_integer/1)
    |> Map.update("children", [], fn(children) ->
      children
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
    end)
  end
end
