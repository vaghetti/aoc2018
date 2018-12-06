defmodule Day5 do
    def input() do
        File.read!("input5.txt") |>
        String.to_charlist()
    end

    def fiberMatch?(a,b) do
        if a == nil or b == nil do
            false
        else
            {a,b} = {List.to_string([a]),List.to_string([b])}
            ((String.upcase(a) == a and String.downcase(b) == b) or (String.upcase(b) == b and String.downcase(a) == a)) and String.downcase(a) == String.downcase(b)
        end
    end

    # TODO: Why is this so slow??
    def react(polymer) do
        Enum.reduce(polymer, %{newPolymer: []}, fn fiber, %{newPolymer: newPolymer} ->
            if fiberMatch?(List.last(newPolymer), fiber)  do
                %{newPolymer: List.delete_at(newPolymer, -1)}
            else
                %{newPolymer: newPolymer ++ [fiber]}
            end
        end) |>
        Map.get(:newPolymer)
    end

    def part1() do
        react(input()) |>
            Enum.count()
    end

    def part2() do
        Enum.map(?a..?z, fn removedChar ->
            filtered = Enum.filter(input(), fn char ->
                String.to_charlist(String.downcase(List.to_string([char]))) != [removedChar]
            end)
            {Enum.count(react(filtered)), [removedChar]} |>
            IO.inspect()
        end) |>
        Enum.min()
    end
end

IO.inspect Day5.part1()
IO.inspect Day5.part2()