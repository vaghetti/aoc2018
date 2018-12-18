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

    def timeSleptPerMinute() do
        input() |>
        Enum.sort( fn a,b -> a[:time] < b[:time] end) |>
        Enum.reduce(%{currentID: 0, timeSleptPerMinute: %{}, fallMinute: 0}, fn %{eventOrID: eventOrID, minute: minute}, acc ->
            %{currentID: currentID, timeSleptPerMinute: timeSleptPerMinute, fallMinute: fallMinute} = acc
            case eventOrID do
                "falls" ->
                    Map.put(acc, :fallMinute, minute)
                "wakes" ->
                    newTimeSleptPerMinute =
                        if timeSleptPerMinute[currentID] do
                            Enum.reduce(fallMinute..(minute-1),  timeSleptPerMinute[currentID], fn thisMinute, asleepMinutes ->
                                List.replace_at(asleepMinutes, thisMinute, Enum.at(asleepMinutes, thisMinute) + 1)
                            end)
                        else
                            Enum.reduce(fallMinute..(minute-1),  Enum.map(0..59, fn _ -> 0 end), fn thisMinute, asleepMinutes ->
                                List.replace_at(asleepMinutes, thisMinute, Enum.at(asleepMinutes, thisMinute) + 1)
                            end)
                        end
                    Map.put(acc, :timeSleptPerMinute, Map.put(timeSleptPerMinute, currentID, newTimeSleptPerMinute))
                _ ->
                    Map.put(acc, :currentID, eventOrID)
            end
        end) |>
        Map.get(:timeSleptPerMinute)
    end

    def part1() do
        timeSleptPerMinute() |>
        Map.to_list() |>
        Enum.map(fn {guardID ,sleepMinutes} ->
            {Enum.sum(sleepMinutes), sleepMinutes, guardID}
        end) |>
        Enum.max() |>
        (fn {_, sleepMinutes, guardID} ->
            mostSleptMinute =
                sleepMinutes |>
                Enum.with_index() |>
                Enum.max() |>
                elem(1)
            String.to_integer(guardID) * mostSleptMinute
        end).()
    end

    def part2() do
        timeSleptPerMinute() |>
        Map.to_list() |>
        Enum.map(fn {guardID ,sleepMinutes} ->
            {Enum.max(sleepMinutes), sleepMinutes, guardID}
        end) |>
        Enum.max() |>
        (fn {_, sleepMinutes, guardID} ->
            mostSleptMinute =
                sleepMinutes |>
                Enum.with_index() |>
                Enum.max() |>
                elem(1)
            String.to_integer(guardID) * mostSleptMinute
        end).()
    end
end

IO.inspect Day4.part1()
IO.inspect Day4.part2()