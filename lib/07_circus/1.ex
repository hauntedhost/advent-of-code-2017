defmodule Circus1 do
  # http://adventofcode.com/2017/day/7

  defmodule Node do
    defstruct [:pid, :name, :weight, :parent_pid, :children]
  end

  def parse_nodes(input) when is_binary(input) do
    input
    |> parse
    |> Stream.flat_map(&create_nodes/1)
    |> Enum.into(%{})
  end

  def create_nodes(%{
    "name" => name,
    "weight" => weight,
    "children" => children,
  } = attrs) do
    {:ok, pid} = Agent.start_link(fn -> %Node{} end)
    children = Enum.map(children, fn(child_name) ->
      create_child(child_name, pid)
    end)
    Agent.update(pid, fn(node) ->
      Map.merge(node, %{
        pid: pid,
        name: name,
        weight: weight,
        children: Enum.into(children, %{}),
      })
    end)
    [{name, pid} | children]
  end

  def create_child(name, parent_pid) do
    {:ok, pid} = Agent.start_link(fn -> %Node{} end)
    Agent.update(pid, fn(node) ->
      Map.merge(node, %{
        pid: pid,
        parent_pid: parent_pid,
        name: name,
      })
    end)
    {name, pid}
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
