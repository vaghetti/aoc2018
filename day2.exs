defmodule Day2 do
    def getList() do
        File.read!("input2.txt") |>
            String.split("\n")
    end

    def part1() do
        getList() |>
            Enum.map(&String.to_charlist(&1)) |>
            Enum.map(&Enum.reduce(&1, %{}, fn newChar, counts -> 
                counts = 
                    if counts[newChar] do
                        Map.put(counts,newChar, counts[newChar] + 1)
                    else
                        Map.put(counts,newChar,  1)
                    end
                counts
            end)) |>
            Enum.map(fn counts -> 
                hasTwo = 
                    if Enum.any?(Map.values(counts), fn x -> x == 2 end) do
                        1
                    else
                        0
                    end
                hasThree = 
                    if Enum.any?(Map.values(counts), fn x -> x == 3 end) do
                         1
                    else
                        0
                    end
                %{:two => hasTwo, :three => hasThree}
            end) |>
            Enum.reduce(%{:two => 0, :three => 0}, fn thisCount, global ->
                %{:two => global[:two] + thisCount[:two], :three => global[:three] + thisCount[:three] }
            end) |>
            (fn x -> 
                x[:two] * x[:three]
                end).()
    end

    def equalChars(a,b) do
        Enum.zip(String.to_charlist(a), String.to_charlist(b)) |>
        Enum.filter(fn charPair -> 
            {char1, char2} = charPair
            char1 == char2
        end) |>
        Enum.map(fn {a,_} -> a end) |>
        to_string
    end

    def part2() do 
        getList() |>
            Enum.map( fn x -> 
                getList() |> 
                    Enum.filter(fn str -> str != x end) |>
                    Enum.zip(Stream.cycle([x])) 
            end) |>
            Enum.map(fn listOfPair -> 
                Enum.map(listOfPair, fn pair -> 
                    Enum.sort(Tuple.to_list(pair))
                end)
            end) |>
            Enum.concat() |>
            Enum.uniq() |>
            Enum.filter(fn [possibleMatch, original] -> 
                equals = equalChars(possibleMatch, original) |>
                String.length(equals) == String.length(original) - 1
            end) |>
            (fn [[a,b]] -> 
                equalChars(a,b)
            end).()
    end
end

IO.inspect Day2.part1()
IO.inspect Day2.part2()