defmodule Day6 do
    def input() do
        File.read!("input6.txt") |>
        String.split("\n") |>
        Enum.map(fn line ->
            [x,y] = String.split(line, ",")
            {String.to_integer(x),String.to_integer(y)}
        end)
    end

    def boxSize() do
        350
    end

    def posMap() do
        input() |>
        Enum.with_index() |>
        Enum.reduce(%{}, fn {pos, posID}, posMap ->
            Map.put(posMap, posID, pos)
        end)
    end

    def distance({x1,y1},{x2,y2}) do
        abs(x1-x2) + abs(y1-y2)
    end

    def positionList() do
        Enum.reduce(0..boxSize(), [], fn y, acc ->
            [Enum.zip(0..boxSize(), Stream.cycle([y])) | acc ]
        end) |>
        List.flatten()
    end

    def posKey({x,y}) do
        {x,y}
    end

    def visualize(closestPerPos) do
        Enum.map(0..boxSize(), fn y ->
            Enum.map(0..boxSize(), fn x ->
                {posID, onlyOwner} = closestPerPos[posKey({x,y})]
                if onlyOwner do
                    Integer.to_string(posID)
                else
                    "."
                end
            end)
        end)
    end

    def closestPerPos() do
        posMap = posMap()
        allPositions = positionList()
        input() |>
        Enum.with_index() |>
        Enum.reduce(%{}, fn {dangerPos, dangerPosID}, closestMap ->
            Enum.reduce(allPositions, closestMap, fn pos, closestMap ->
                key = posKey(pos)
                if closestMap[key] do
                    {previousDangerPosID,_} = closestMap[key]
                    previousDangerPos = posMap[previousDangerPosID]
                    if distance(previousDangerPos, pos) > distance(dangerPos, pos) do
                        %{closestMap | key =>  {dangerPosID, true}}
                    else
                        if distance(previousDangerPos, pos) == distance(dangerPos, pos) do
                            %{closestMap | key => {previousDangerPosID, false}}
                        else
                            closestMap
                        end
                    end
                else
                    Map.put(closestMap,key,{dangerPosID,true})
                end
            end)
        end)
    end

    def isLimit({x,y}) do
        x ==0 or y==0 or x== boxSize() or y==boxSize()
    end

    def part1() do
        closestPerPos() |>
        Map.to_list() |>
        Enum.filter(fn {_, {_, isOnlyOwner}} ->
            isOnlyOwner
        end) |>
        Enum.reduce(%{}, fn {pos, {dangerPosID, _}}, count ->
            if isLimit(pos) do
                Map.put(count,dangerPosID, -10000000)
            else
                if count[dangerPosID] do
                    %{count | dangerPosID => count[dangerPosID] + 1 }
                else
                    Map.put(count,dangerPosID, 1)
                end
            end
        end) |>
        Map.values() |>
        Enum.max()
    end
end

IO.inspect Day6.part1()