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

    def getKey(x,y) do
        Integer.to_string(y)<>" "<>Integer.to_string(x)
    end

    def getOverlapCount() do
        Enum.reduce(Enum.with_index(getList()), %{}, fn {%{stX: stX, stY: stY, endX: endX , endY: endY}, _} , matrix ->
            Enum.reduce(posPairs(stX, stY, endX, endY), matrix, fn {x,y}, matrix ->
                key = getKey(x,y)
                if matrix[key] do
                    Map.put(matrix, key, matrix[key] + 1)
                else
                    Map.put(matrix, key,  1)
                end
            end)
        end)
    end

    def part1() do
        getOverlapCount() |>
        Map.values() |>
        List.flatten() |>
        Enum.filter(fn x -> x >= 2 end) |>
        Enum.count()
    end

    def posPairs(stX, stY, endX, endY) do
        yRange = stY..endY-1
        xRange = stX..endX-1
        Enum.map(yRange, fn yPos ->
            Enum.zip(xRange, Stream.cycle([yPos]))
        end) |>
        List.flatten()
    end

    def part2() do
        counts = getOverlapCount()

        Enum.filter(Enum.with_index(getList(),1), fn {%{stX: stX, stY: stY, endX: endX , endY: endY}, _} ->
            posPairs = posPairs(stX, stY, endX, endY)
            Enum.all?(posPairs, fn {x,y} -> counts[getKey(x,y)] == 1 end)
        end)
    end
end

IO.inspect Day3.part1()
IO.inspect Day3.part2()