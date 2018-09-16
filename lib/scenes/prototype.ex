defmodule ScenicPlanet.Scene.Prototype do
  use Scenic.Scene
  import Scenic.Primitives, only: [{:rect, 3}, {:update_opts, 2}]
  alias Scenic.Graph

  @player_width 10
  @player_height 25
  @update_every_ms 16

  @graph Graph.build(clear_color: :dark_slate_blue)
         |> rect({@player_width, @player_height}, id: :player, fill: :light_coral)

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

  def vec3_sub({ax, ay}, {bx, by}) do
    {ax - bx, ay - by}
  end

  def vec3_add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  # TODO: Handle zero vectors, to avoid division by zero.
  def vec3_normalize({x, y} = v) do
    m = vec3_magnitude(v)
    {x / m, y / m}
  end

  def vec3_magnitude({x, y}) do
    :math.sqrt(x * x + y * y)
  end

  def vec3_scale({x, y}, c) do
    {x * c, y * c}
  end

  #
  # Player entity: updating player state.
  #

  # State -> State
  def player_update(%{pos: pos, seek_to: seek_to} = state) do
    # Move towards `seek_to`.
    diff = vec3_scale(vec3_normalize(vec3_sub(seek_to, pos)), 5)
    new_pos = vec3_add(pos, diff)
    %{state | pos: new_pos}
  end

  #
  # Player entity: updating graph.
  #

  # Graph -> State -> Graph
  def player_draw(graph, %{pos: pos} = _state) do
    Graph.modify(graph, :player, &update_opts(&1, translate: pos))
  end

  #
  # Update callback.
  #

  def handle_info(:update, %{graph: graph} = state) do
    # Update game state.
    state = player_update(state)

    # Draw game state, by pushing state to viewport.
    graph
    |> player_draw(state)
    |> push_graph()

    # Return updated state.
    {:noreply, %{state | graph: graph}}
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
