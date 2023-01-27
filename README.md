# Aoc 2022

https://adventofcode.com/2022

Originally I made each day in a separate folder. All those can be found inside `days/`

But now I intend to wrap everything in a mix project (`aoc/` folder)

The reason for that is that some code could be reused.

So `aoc/` contains a `utils.ex` module for opening inputs, and then one module per day.

Only the first day exists in this `aoc/` project for now


## First (old) way

    cd advent_of_code_2022/days/day1
    elixir solution.ex

## Preferred (new) way

    cd advent_of_code_2022/aox
    iex -S mix

    iex(1)> One.part_one()
    iex(2)> One.part_two()
