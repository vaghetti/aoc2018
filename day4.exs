defmodule Day4 do
    def input() do
        File.read!("input4.txt") |>
        String.split("\n") |>
        Enum.map(&String.split(&1," ")) |>
        Enum.map(fn [year, month, day, hour, minute, eventOrID] ->
            %{time: timeKey(year,month,day,hour, minute), eventOrID: eventOrID, minute: String.to_integer(minute)}
        end)
    end

    def timeKey(year,month,day, hour, minute) do
         year<>" "<>month<>" "<>day<>" "<>hour<>" "<>minute
    end

    def part1() do
        input() |>
        Enum.sort( fn a,b -> a[:time] < b[:time] end) |>
        Enum.reduce(%{currentID: 0, totalSleep: %{}, fallMinute: 0}, fn %{ eventOrID: eventOrID, minute: minute}, acc ->
            %{currentID: currentID, totalSleep: totalSleep, fallMinute: fallMinute} = acc
            case eventOrID do
                "falls" ->
                    Map.put(acc, :fallMinute, minute)
                "wakes" ->
                    mapEntry =
                        if totalSleep[currentID] do
                            sleepTime = minute - fallMinute + elem(totalSleep[currentID],0)
                            asleepMinutes = Enum.reduce(fallMinute..(minute-1),  elem(totalSleep[currentID], 1), fn sleepingMinute, asleepMinutes ->
                                List.replace_at(asleepMinutes, sleepingMinute, Enum.at(asleepMinutes, sleepingMinute) + 1)
                            end)
                            {sleepTime, asleepMinutes, currentID}
                        else
                            sleepTime = minute - fallMinute
                            asleepMinutes = Enum.reduce(fallMinute..(minute-1),  Enum.map(0..59, fn _ -> 0 end), fn sleepingMinute, asleepMinutes ->
                                #IO.inspect asleepMinutes
                                List.replace_at(asleepMinutes, sleepingMinute, Enum.at(asleepMinutes, sleepingMinute) + 1)
                            end)
                            {sleepTime, asleepMinutes, currentID}
                        end


                    Map.put(acc, :totalSleep, Map.put(totalSleep, currentID, mapEntry))
                _ ->
                    Map.put(acc, :currentID, eventOrID)
            end
        end) |>
        (fn x -> x[:totalSleep] end).() |>
        Map.values() |>
        Enum.max() |>
        (fn {_, sleepMinutes, guardID} ->
            mostSleptMinute =
                sleepMinutes |>
                Enum.with_index() |>
                Enum.max() |>
                elem(1)
            IO.inspect mostSleptMinute
            IO.inspect guardID
            String.to_integer(guardID) * mostSleptMinute
        end).()
    end
end

IO.inspect Day4.part1()