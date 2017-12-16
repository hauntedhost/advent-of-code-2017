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

  def update_nodes(nodes, %{name: name, children: []} = attrs) do
    case nodes[name] do
      nil         -> Map.put(nodes, name, create_node(attrs))
      %{pid: pid} -> Map.put(nodes, name, update_node(pid, attrs))
    end
  end

  def update_nodes(nodes, %{
    name: parent_name,
    children: [child_name | children],
  } = attrs) do
    nodes = case {nodes[parent_name], nodes[child_name]} do
      {nil, nil} ->
        # create parent
        %{pid: parent_pid} = parent = create_node(attrs)

        # create child with parent_pid
        child = create_node(%{
          name: child_name,
          parent_pid: parent_pid,
        })

        # add child to parent
        add_child(nodes, parent, child)
      {nil, child} ->
        # create parent
        parent = create_node(attrs)

        # add child to parent
        add_child(nodes, parent, child)
      {%{pid: parent_pid} = parent, nil} ->
        # create child with parent_pid
        child = create_node(%{
          name: child_name,
          parent_pid: parent_pid,
        })

        # add child to parent
        add_child(nodes, parent, child)
      {parent, child} ->
        # add child to parent
        add_child(nodes, parent, child)
    end
    update_nodes(nodes, %{attrs | children: children})
  end

  def add_child(nodes, %{pid: parent_pid} = parent, %{pid: child_pid} = child) do
    # update child with parent_pid
    child = update_node(child_pid, %{child | parent_pid: parent_pid})

    # add child to parent
    Agent.update(parent_pid, fn(parent) ->
        Map.update(parent, :children, %{child.name => child}, fn(children) ->
          Map.merge(children, %{
            child.name => child,
          })
        end)
    end)
    parent = Agent.get(parent_pid, &(&1))

    # merge into nodes
    Map.merge(nodes, %{
      parent.name => parent,
      child.name => child,
    })
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
        name: Map.get(attrs, :name),
        weight: Map.get(attrs, :weight),
      })
      |> Map.update(:parent_pid, nil, fn
        (nil) -> Map.get(attrs, :parent_pid)
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
