defmodule Circus1 do
  # http://adventofcode.com/2017/day/7

  defmodule Node do
    defstruct [:pid, :name, :weight, :parent_pid, :children]
  end

  def parse_nodes(input) when is_binary(input) do
    input
    |> parse
    |> Enum.reduce(%{}, fn(attrs, nodes) ->
      update_nodes(nodes, attrs)
    end)
  end

  def update_nodes(nodes, %{"name" => name} = attrs) do
    case nodes[name] do
      nil -> Map.put(nodes, name, create_node(attrs))
      pid -> Map.put(nodes, name, update_node(pid, attrs))
    end
  end

  def create_node(attrs) do
    {:ok, pid} = Agent.start_link(fn -> %Node{} end)
    update_node(pid, attrs)
  end

  def update_node(pid, attrs) do
    Agent.update(pid, fn(node) ->
      Map.merge(node, %{
        pid: pid,
        name: attrs["name"],
        weight: attrs["weight"],
      })
    end)
    pid
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
