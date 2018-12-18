defmodule Day7 do
    def input() do
        File.read!("input7.txt") |>
        String.split("\n") |>
        Enum.map(&String.split(&1," ")) |>
        Enum.map(fn [a,b] -> {a,b} end)
    end

    def depMap(input) do
        Enum.reduce(input, %{}, fn {a,b}, depMap ->
            if depMap[b] do
                Map.put(depMap, b, [a | depMap[b]])
            else
                Map.put(depMap, b, [a])
            end
        end)
    end

    def allTasks() do
        input() |>
        Enum.map(fn {a,b} -> [a,b] end) |>
        List.flatten() |>
        MapSet.new()
    end

    def possibleMoves(depMap, allTasks,  done) do
        Enum.filter(MapSet.to_list(allTasks), fn attempt ->
            if MapSet.member?(done,attempt) do
                false
            else 
                if depMap[attempt] do
                    Enum.all?(depMap[attempt], fn dep -> MapSet.member?(done, dep) end)
                else
                    true
                end
            end
        end)
    end

    def part1()  do
        depMap = depMap(input())
        allTasks = allTasks()
        
        Enum.reduce_while(1..100, %{done: MapSet.new(), list: []} , fn _, %{done: done, list: list} ->
            next =  possibleMoves(depMap, allTasks, done) |>
            Enum.take(1)
            
            if next != [] do
                {:cont, %{done: MapSet.union(done, MapSet.new(next)), list: list ++ next}}
            else
                {:halt, list}
            end
        end) |>
        Enum.join("")
    end

    def baseCost(step, baseTime) do
        [step] |>
        to_string() |>
        String.downcase() |>
        String.to_charlist() |>
        List.first() |>
        (fn x -> x-?a + baseTime + 1 end).()
    end


    def part2() do
        depMap = depMap(input())
        allTasks = allTasks()
        workers = 5
        baseTime = 60

        costMap = Enum.reduce(allTasks, %{},  fn task, costMap ->
            Map.put(costMap, task, baseCost(task,baseTime))
        end)
        
        Enum.reduce_while(1..100, %{done: MapSet.new(), totalCost: 0, costMap: costMap, stillWorking: []} , fn _, %{done: done, totalCost: totalCost, costMap: costMap, stillWorking: stillWorking } ->
            next =  stillWorking ++ possibleMoves(depMap, allTasks, done) |>
            Enum.uniq() |>
            Enum.take(workers) |>
            Enum.map(fn x -> to_string([x]) end)

            if Enum.count(next) > 0 do

                stepTime = Enum.map(next, fn task -> costMap[task] end) |>
                    Enum.min()
                
                costMap = Enum.reduce(next, costMap, fn task, costMap ->
                    Map.put(costMap, task, costMap[task] - stepTime)
                end)

                doneTasks = Enum.filter(next, fn task ->
                    costMap[task] <= 0 
                end)

                stillWorking = Enum.filter(next, fn task ->
                    costMap[task] >= 1 
                end)
                
                {:cont, %{done: MapSet.union(done, MapSet.new(doneTasks)), 
                          totalCost: totalCost + stepTime, 
                          costMap: costMap,
                          stillWorking: stillWorking}}
            else
                {:halt, totalCost}
            end
        end) 
    end
end

IO.inspect Day7.part1()
IO.inspect Day7.part2()

