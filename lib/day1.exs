defmodule Day1 do
    def getList(input) do
        File.read!(input) |>
            String.split("\n")  |>
            Enum.map(&String.to_integer(&1))
    end

    def part1(input) do 
        getList(input) |>
            Enum.sum
    end

    def part2(input) do
        list = getList(input)
        Enum.reduce_while(Stream.cycle(list), %{:seen => MapSet.new([]), :sum => 0}, fn x,acc ->
            %{:seen => seen, :sum => sum} = acc
            newSum = x + sum
            if MapSet.member?(seen, newSum) do
                {:halt, newSum}
            else
                newMap = MapSet.put(seen, newSum)
                {:cont, %{:seen => newMap, :sum => newSum}}
            end
        end)
    end
end

IO.puts Day1.part1("input1.txt")
IO.puts Day1.part2("input1.txt")


