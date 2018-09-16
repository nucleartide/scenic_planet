defmodule ScenicPlanet.Scene.Prototype do
  use Scenic.Scene
  import Scenic.Primitives, only: [{:rect, 3}]
  alias Scenic.Graph

  @player_width 10
  @player_height 25

  @graph Graph.build()
         |> rect({@player_width, @player_height}, fill: :light_coral)

  def init(nil, opts) do
    IO.puts("hello world, it's working!")

    state = %{
      graph: @graph
    }

    push_graph(@graph)
    {:ok, state}
  end
end
