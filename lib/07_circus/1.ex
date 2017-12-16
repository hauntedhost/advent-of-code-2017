defmodule Circus1 do
  # http://adventofcode.com/2017/day/7

  defmodule Node do
    defstruct [:pid, :name, :weight, :parent_pid, children: %{}]
  end

  def parse_nodes(input) when is_binary(input) do
    input
    |> parse
    |> Enum.reduce(%{}, fn(attrs, nodes) ->
      update_nodes(nodes, attrs)
    end)
  end

  def update_nodes(nodes, %{:name => name, :children => []} = attrs) do
    case nodes[name] do
      nil         -> Map.put(nodes, name, create_node(attrs))
      %{pid: pid} -> Map.put(nodes, name, update_node(pid, attrs))
    end
  end

  def update_nodes(nodes, %{
    :name => parent_name,
    :children => [child_name | children],
  } = attrs) do
    nodes = case {nodes[parent_name], nodes[child_name]} do
      {nil, nil} ->
        %{pid: parent_pid} = create_node(attrs)
        child_node = create_node(%{
          :name => parent_name,
          :parent_pid => parent_pid,
        })
        parent_node = add_child(parent_pid, child_node)
        Map.merge(nodes, %{
          parent_node.name => parent_node,
          child_node.name => child_node,
        })
      {nil, %{pid: child_pid} = child_node} -> # TODO: update child_node with parent_pid
        %{pid: parent_pid} = create_node(attrs)
        # child_node = update_node(child_pid, )
        parent_node = add_child(parent_pid, child_node)
        Map.merge(nodes, %{
          parent_node.name => parent_node,
        })
      {%{pid: parent_pid}, nil} ->
        child_node = create_node(%{
          :name => parent_name,
          :parent_pid => parent_pid,
        })
        parent_node = add_child(parent_pid, child_node)
        Map.merge(nodes, %{
          parent_node.name => parent_node,
          child_node.name => child_node,
        })
      {%{pid: parent_pid}, child_node} ->
        parent_node = add_child(parent_pid, child_node)
        Map.merge(nodes, %{
          parent_node.name => parent_node,
        })
    end
    update_nodes(nodes, %{attrs | :children => children})
  end

  def add_child(parent_pid, %{pid: child_pid} = child_node) do
    Agent.update(parent_pid, fn(node) ->
        Map.update(node, :children, %{child_node.name => child_node}, fn(children) ->
          Map.merge(children, %{
            child_node.name => child_node,
          })
        end)
    end)
    Agent.get(parent_pid, &(&1))
  end

  def create_node(attrs) do
    {:ok, pid} = Agent.start_link(fn -> %Node{} end)
    update_node(pid, attrs)
  end

  def update_node(pid, attrs) do
    Agent.update(pid, fn(node) ->
      node
      |> Map.merge(%{
        pid: pid,
        name: attrs[:name],
        weight: attrs[:weight],
      })
      |> Map.update(:parent_pid, nil, fn
        (nil) -> attrs[:parent_pid]
        (pid) -> pid
      end)
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
    |> Map.new(fn({k, v}) -> {String.to_atom(k), v} end)
    |> Map.update(:weight, nil, &String.to_integer/1)
    |> Map.update(:children, [], fn(children) ->
      children
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
    end)
  end
end
