defmodule ScenicPlanet.Scene.Prototype do
  use Scenic.Scene
  import Scenic.Primitives, only: [{:rect, 3}]
  alias Scenic.Graph

  @player_width 10
  @player_height 25
  @update_every_ms 16

  @graph Graph.build()
         |> rect({@player_width, @player_height}, fill: :light_coral)

  #
  # Init callback.
  #

  def init(nil, _opts) do
    # Define our state.
    state = %{
      graph: @graph,

      # Player properties.
      pos: {0, 0},
      seek_to: {200, 200}
    }

    # Set up our game loop.
    :timer.send_interval(@update_every_ms, :update)

    # Push our graph down to the viewport.
    push_graph(@graph)

    # Return OK tuple.
    {:ok, state}
  end

  #
  # Math utils.
  #

  #
  # Player entity: updating player state.
  #

  # State -> State
  def player_update(%{pos: pos, seek_to: seek_to} = state) do
    # Move towards `seek_to`.
  end

  #
  # Player entity: updating graph.
  #

  # Graph -> State -> Graph
  def player_draw() do
  end

  #
  # Update callback.
  #

  def handle_info(:update, state) do
    # IO.puts("update")
    {:noreply, state}
  end

  #
  # Handle input.
  #

  # Update `seek_to` variable.
  def handle_input({:cursor_button, {:left, :press, _, {_x, _y} = seek_to}}, _context, state) do
    state = %{state | seek_to: seek_to}
    {:noreply, state}
  end

  def handle_input(_input, _context, state), do: {:noreply, state}
end
