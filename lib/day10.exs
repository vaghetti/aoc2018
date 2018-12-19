defmodule Day10 do
    def input() do
        File.read!("input10.txt") |>
        String.split("\n") |>
        Enum.map(fn line ->
            [px,py,vx,vy] = String.split(line, " ") |> 
            Enum.map(&String.to_integer(&1))
            {{px,py},{vx,vy}}
        end)
    end

    def boundingBox(positions) do
        allX = Enum.map(positions,&elem(&1,0)) 
        allY = Enum.map(positions,&elem(&1,1))
        {{Enum.min(allX)-1, Enum.min(allY)-1}, {Enum.max(allX)+1, Enum.max(allY)+1}}
    end

    def size({{minX,minY}, {maxX,maxY}}) do
        Enum.max([maxX-minX, maxY-minY])
    end

    def print(positions) do
        {{minX,minY}, {maxX,maxY}} = boundingBox(positions)
        posSet = MapSet.new(positions)

        Enum.reduce(minY..maxY, fn y, _ -> 
            Enum.map(minX..maxX, fn x ->
                if MapSet.member?(posSet, {x,y}) do
                    "#"
                else
                    " "
                end
            end) |>
            Enum.join() |>
            IO.inspect()
        end)
    end

    def part1() do
        data = input()
        posList = Enum.map(data,&elem(&1,0))
        speedList = Enum.map(data,&elem(&1,1))

        Enum.reduce_while(1..999999, %{posList: posList, prevPosList: [], prevSize: 99999999} ,
            fn second, %{posList: posList, prevSize: prevSize} ->
            newPosList = Enum.zip(posList , speedList) |>
                        Enum.map(fn {{px,py}, {vx,vy}} -> 
                            {px+vx, py+vy}
                        end) 
            currentSize = size(boundingBox(newPosList)) 
            if currentSize > prevSize do
                {:halt, {posList, second-1}}
            else
                {:cont, %{posList: newPosList, prevSize: currentSize}}
            end
        end) |>
        (fn {posList, second} ->
            print(posList)
            IO.inspect(second, label: "seconds")
        end).()
    end
end

Day10.part1()