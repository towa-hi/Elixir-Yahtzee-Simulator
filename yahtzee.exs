defmodule Yahtzee do
  @moduledoc """
  Starts a game of yahtzee, rolling five die and printing the results, the pattern of the results and the probability of the evaluation.

  the data flow looks like this:

  startGame begins
    roll() creates a unsorted array of five integers
      evalPatterns() takes the results of roll() and sorts it
        highestOfKind() takes sorted array and returns a string depending on what pattern it is
        if highestOfKind() returns the string "Nothing", pass the sorted array into evalStraights()
          evalStraights() takes the sorted array and passes it into highestStraight()
            highestStraight() returns a single int describing the length of the longest straight found
          evalStraights() turns this single int into a string describing the pattern
      evalPatterns() returns the final string that describes what pattern the rolls were
    evalProbability() takes the string that describes the pattern and returns a string that describes the probability of said pattern
  startGame prints the current count, results of the roll, pattern of the roll and probability

  """
  def startGame() do
    IO.gets("Input anything to start rolling")

    for count <- 1..12 do
      rolls = roll()
      pattern = evalPatterns(rolls)
      probability = evalProbability(pattern)
      IO.puts("#{count} \t #{inspect(rolls)} #{pattern} \t #{probability}")
    end
    startGame()
  end

#not done yet
  #input: string describing the pattern like "Full House"
  #output: string describing the probability of the input pattern
  def evalProbability(pattern) do
    case pattern do
      "Yahtzee" ->  "0.00024"
      "Full House" -> "n/a"
      "Four of a Kind" -> "n/a"
      "Three of a Kind" -> "n/a"
      "Large Straight" ->  "0.0146"
      "Small Straight" -> "n/a"
      _ -> "n/a"
    end
  end

  #input: unsorted array of five integers
  #output: string describing the pattern like "Full House"
  def evalPatterns(rolls) do
    sortedRolls = Enum.sort(rolls)
    highestOfKind = evalHighestOfKind(sortedRolls)
    if highestOfKind == "Nothing" do
      evalStraights(sortedRolls)
    else
      highestOfKind
    end
  end

  #input: void
  #output: unsorted array of five integers between 1 and 8 like [1,2,3,4,8]
  def roll() do
    for _ <- 0..4 do
      result = Enum.random(1..8)
      #IO.puts("You rolled #{result}")
      result
    end
  end

  #input: unsorted array of five integers between 1 and 8 like [1,2,3,4,8]
  #output: string describing the pattern if it has a straight in it. returns "Nothing" if no small or large straight found.
  def evalStraights(list) do
    case highestStraight(list) do
      5 -> "Large Straight"
      4 -> "Small Straight"
      _ -> "Nothing"
    end
  end

  #input: unsorted array of five integers between 1 and 8 like [1,2,3,4,8]
  #output: string describing the pattern if it has duplicate values in it. returns "Nothing" if nothing in the pattern list is found.
  def evalHighestOfKind(list) do
    #IO.inspect(list)
    Enum.group_by(list, &(&1))
    |>Enum.map(fn {_key, val} -> length(val) end)
    |>Enum.uniq
    |>Enum.sort
    |>case do
      [5] -> "Yahtzee"
      [2,3] -> "Full House"
      [1,4] -> "Four of a Kind"
      [1,3] -> "Three of a Kind"
      _ -> "Nothing"
    end
  end

  #input: unsorted array of five integers between 1 and 8 like [1,2,3,4,8]
  #output: integer describing the length of the biggest straight found in the array
  def highestStraight(list) do
    uniqueList = Enum.uniq(list)
    #IO.inspect(uniqueList, label: "highestStraight() is analyzing a unique list that looks like this")
    highestStraight(uniqueList, 0, 1, 1)
  end

  def highestStraight(list, acc, streak, highest) do
    currentVal = Enum.at(list, acc)
    cond do
      acc >= length(list) - 1 -> highest
      Enum.member?(list, currentVal + 1) -> highestStraight(list, acc + 1, streak + 1, max(streak + 1, highest))
      true -> highestStraight(list, acc + 1, 1, highest)
    end
  end
end

#run game in console
Yahtzee.startGame
