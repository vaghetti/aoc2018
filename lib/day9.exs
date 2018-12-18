defmodule Day9 do

    # Double-linked list shamelessly copied from the internet
    defmodule Circle do

        def new(value) do
            {[], value, []}
        end

        def current({_, current, _}), do: current

        def rotate_cw({left, current, []}) do
            [new_current | right] = Enum.reverse([current | left])
            {[], new_current, right}
        end

        def rotate_cw({left, current, [right_first | right]}) do
            {[current | left], right_first, right}
        end

        def rotate_ccw({[], current, right}) do
            [new_current | left] = Enum.reverse([current | right])
            {left, new_current, []}
        end

        def rotate_ccw({[left_first | left], current, right}) do
            {left, left_first, [current | right]}
        end

        def rotate_ccw(circle, 0), do: circle
        def rotate_ccw(circle, n), do: circle |> rotate_ccw() |> rotate_ccw(n - 1)

        def add_cw({left, current, right}, value) do
            {left, current, [value | right]}
        end

        def remove_current({left, _current, [right_first | right]}) do
            {left, right_first, right}
        end
    end

    def input() do
        File.read!("input9.txt") |>
        String.split(" ") |>
        Enum.map(&String.to_integer(&1)) |>
        (fn [a,b] -> {a,b} end).()
    end

    def part1() do
        {players, lastMarble} = input()
        playerScores = Enum.reduce(1..players, %{}, fn player, playerScores ->
            Map.put(playerScores, player, 0)
        end)

        marblePlayerPairs = Stream.zip(1..lastMarble, Stream.cycle(1..players) |> Enum.take(lastMarble))

        Enum.reduce(marblePlayerPairs,  %{playerScores: playerScores, marbles: Circle.new(0)}, 
            fn {newMarble,player}, %{playerScores: playerScores, marbles: marbles} ->
            if rem(newMarble, 23) == 0 do
                marbles = Circle.rotate_ccw(marbles,7)
                newScore = playerScores[player] + newMarble + Circle.current(marbles)
                playerScores = %{playerScores | player => newScore}
                marbles = Circle.remove_current(marbles)
                %{playerScores: playerScores, marbles: marbles}
            else
                marbles = Circle.rotate_cw(marbles)
                marbles = Circle.add_cw(marbles, newMarble)
                marbles = Circle.rotate_cw(marbles)
                %{playerScores: playerScores, marbles: marbles}
            end
        end) |>
        Map.get(:playerScores) |>
        Map.values() |>
        Enum.max()
    end
end

IO.inspect Day9.part1()