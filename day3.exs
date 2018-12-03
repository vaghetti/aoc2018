defmodule Day3 do
    def getList() do
        File.read!("input3.txt") |>
            String.split("\n") |>
            Enum.map(fn line ->
                [startX, startY, lenX, lenY] = String.split(line, " ") |>
                    Enum.map(&String.to_integer(&1))
                %{stX:  startX, stY: startY, endX: startX+lenX, endY: startY+lenY}
            end)
    end

    def part1() do
        size = 1005
        initialMatrix = Enum.map(0..size-1, fn _ ->
            Enum.map(0..size-1, fn _ -> 0 end)
        end)

        Enum.reduce(Enum.with_index(getList()), initialMatrix, fn {%{stX: stX, stY: stY, endX: endX , endY: endY}, claimID} , matrix ->
            Enum.map(Enum.with_index(matrix), fn {line, yIndex} ->
                Enum.map(Enum.with_index(line), fn {claimCount, xIndex} ->
                    if xIndex >= stX and xIndex < endX and yIndex >= stY and yIndex < endY do
                        claimCount + 1
                    else
                        claimCount
                    end
                end)
            end)
        end) |>
        List.flatten() |>
        Enum.filter(fn x -> x >= 2 end) |>
        Enum.count()
    end

    def part2() do
    end
end

IO.inspect Day3.part1()
IO.inspect Day3.part2()