defmodule Circus1Test do
  use ExUnit.Case, async: true

  @input """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
  """

  test "find_root_name for circus.txt returns azqje" do
    circus =
      [File.cwd!, "files", "circus.txt"]
      |> Path.join
      |> File.read!

    assert Circus1.find_root_name(circus) == "azqje"
  end


  test "find_root_name for @input returns 'tknk'" do
    assert Circus1.find_root_name(@input) == "tknk"
  end

  test "find_root for @input returns root Node" do
    assert %Circus1.Node{
      children: %{
        "fwft" => _,
        "padx" => _,
        "ugml" => _,
      },
      name: "tknk",
      parent_pid: nil,
      pid: _,
      weight: 41,
    } = Circus1.find_root(@input)
  end

  test "parse_nodes for @input returns expected map of Nodes" do
    assert %{
      "cntj" => %Circus1.Node{
        children: %{},
        name: "cntj",
        parent_pid: _,
        pid: _,
        weight: 57,
      },
      "ebii" => %Circus1.Node{
        children: %{},
        name: "ebii",
        parent_pid: _,
        pid: _,
        weight: 61,
      },
      "fwft" => %Circus1.Node{
        children: %{
          "cntj" => _,
          "ktlj" => _,
          "xhth" => _,
        },
        name: "fwft",
        parent_pid: _,
        pid: _,
        weight: 72,
      },
      "gyxo" => %Circus1.Node{
        children: %{},
        name: "gyxo",
        parent_pid: _,
        pid: _,
        weight: 61,
      },
      "havc" => %Circus1.Node{
        children: %{},
        name: "havc",
        parent_pid: _,
        pid: _,
        weight: 66,
      },
      "jptl" => %Circus1.Node{
        children: %{},
        name: "jptl",
        parent_pid: _,
        pid: _,
        weight: 61
      },
      "ktlj" => %Circus1.Node{
        children: %{},
        name: "ktlj",
        parent_pid: _,
        pid: _,
        weight: 57,
      },
      "padx" => %Circus1.Node{
        children: %{
          "havc" => _,
          "pbga" => _,
          "qoyq" => _,
        },
        name: "padx",
        parent_pid: _,
        pid: _,
        weight: 45,
      },
      "pbga" => %Circus1.Node{
        children: %{},
        name: "pbga",
        parent_pid: _,
        pid: _,
        weight: 66,
      },
      "qoyq" => %Circus1.Node{
        children: %{},
        name: "qoyq",
        parent_pid: _,
        pid: _,
        weight: 66,
      },
      "tknk" => %Circus1.Node{
        children: %{
          "fwft" => _,
          "padx" => _,
          "ugml" => _,
        },
        name: "tknk",
        parent_pid: nil,
        pid: _,
        weight: 41,
      },
      "ugml" => %Circus1.Node{
        children: %{
          "ebii" => _,
          "gyxo" => _,
          "jptl" => _,
        },
        name: "ugml",
        parent_pid: _,
        pid: _,
        weight: 68,
      },
      "xhth" => %Circus1.Node{
        children: %{},
        name: "xhth",
        parent_pid: _,
        pid: _,
        weight: 57,
      }} = Circus1.parse_nodes(@input)
  end

  test "parse @input returns expected list of maps" do
    result = Circus1.parse(@input)

    assert Enum.to_list(result) == [
      %{name: "pbga", weight:  66, children: []},
      %{name: "xhth", weight:  57, children: []},
      %{name: "ebii", weight:  61, children: []},
      %{name: "havc", weight:  66, children: []},
      %{name: "ktlj", weight:  57, children: []},
      %{name: "fwft", weight:  72, children: ["ktlj", "cntj", "xhth"]},
      %{name: "qoyq", weight:  66, children: []},
      %{name: "padx", weight:  45, children: ["pbga", "havc", "qoyq"]},
      %{name: "tknk", weight:  41, children: ["ugml", "padx", "fwft"]},
      %{name: "jptl", weight:  61, children: []},
      %{name: "ugml", weight:  68, children: ["gyxo", "ebii", "jptl"]},
      %{name: "gyxo", weight:  61, children: []},
      %{name: "cntj", weight:  57, children: []},
    ]
  end
end
