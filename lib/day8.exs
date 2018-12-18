defmodule Day8 do
    def input() do
        File.read!("input8.txt") |>
        String.split(" ") 
    end

    def genTree(data) do
        # IO.inspect({"data", data})
        [childrenCount, metadataCount | tail] = data
        metadataCount = String.to_integer(metadataCount)
        childrenCount = String.to_integer(childrenCount)

        %{tail: tail, children: children} = 
            if childrenCount != 0 do
                Enum.reduce(1..childrenCount, %{tail: tail, children: []}, fn _, %{tail: tail, children: children} ->
                    if tail != [] do
                        %{tail: tail, tree: tree} = genTree(tail)
                        %{tail: tail, children: children ++ [tree]}
                    else
                        %{tail: tail, children: children}
                    end
                end)
            else
                %{tail: tail, children: []}
            end
        metadata =  Enum.take(tail,metadataCount) |> Enum.map(&String.to_integer(&1))
        tail = Enum.drop(tail, metadataCount)
        %{tail: tail, tree: %{data: metadata, children: children} }
    end

    def metadataSum(tree) do
        Enum.sum(tree.data) + Enum.reduce(tree.children, 0, fn subTree, sum -> 
            sum + metadataSum(subTree)
        end)
    end

    def indexedSum(tree) do
        if tree.children != [] do
            Enum.reduce(tree.data, 0, fn metadataIndex, sum ->
                if metadataIndex == 0 or metadataIndex > Enum.count(tree.children)  do
                    sum
                else
                    sum+indexedSum(Enum.at(tree.children,metadataIndex-1))
                end
            end)
        else
            Enum.sum(tree.data)
        end 
    end

    def part1() do
        input() |>
        genTree() |>
        Map.get(:tree) |>
        metadataSum()
    end

    def part2() do
        input() |>
        genTree() |>
        Map.get(:tree) |> 
        indexedSum()
    end
end

IO.inspect Day8.part1()
IO.inspect Day8.part2()