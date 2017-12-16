defmodule Circus1Test do
  use ExUnit.Case, async: true

  test "parse parses" do
    input = """
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

    result = Circus1.parse(input)

    assert Enum.to_list(result) == [
      %{"name" =>  "pbga", "weight" =>  66, "children" => []},
      %{"name" =>  "xhth", "weight" =>  57, "children" => []},
      %{"name" =>  "ebii", "weight" =>  61, "children" => []},
      %{"name" =>  "havc", "weight" =>  66, "children" => []},
      %{"name" =>  "ktlj", "weight" =>  57, "children" => []},
      %{"name" =>  "fwft", "weight" =>  72, "children" => ["ktlj", "cntj", "xhth"]},
      %{"name" =>  "qoyq", "weight" =>  66, "children" => []},
      %{"name" =>  "padx", "weight" =>  45, "children" => ["pbga", "havc", "qoyq"]},
      %{"name" =>  "tknk", "weight" =>  41, "children" => ["ugml", "padx", "fwft"]},
      %{"name" =>  "jptl", "weight" =>  61, "children" => []},
      %{"name" =>  "ugml", "weight" =>  68, "children" => ["gyxo", "ebii", "jptl"]},
      %{"name" =>  "gyxo", "weight" =>  61, "children" => []},
      %{"name" =>  "cntj", "weight" =>  57, "children" => []},
    ]

    IO.inspect Circus1.parse_nodes(input)
  end
end
