defmodule AkinTest do
  use ExUnit.Case
  import Akin

  test "requesting a subset of algorithms in the options results in expected phonetic algorithms" do
    all_phonetic = algorithms(metric: "phonetic")
    whole_phonetic = algorithms(metric: "phonetic", unit: "whole")
    partial_phonetic = algorithms(metric: "phonetic", unit: "partial")

    assert all_phonetic == ["metaphone", "double_metaphone", "substring_double_metaphone"]
    assert whole_phonetic == ["metaphone", "double_metaphone"]
    assert partial_phonetic == ["substring_double_metaphone"]
  end

  test "requesting a subset of algorithms in the options results in expected string algorithms" do
    all_string = algorithms(metric: "string")
    whole_string = algorithms(metric: "string", unit: "whole")
    partial_string = algorithms(metric: "string", unit: "partial")

    assert all_string == [
             "bag_distance",
             "levenshtein",
             "jaro_winkler",
             "jaccard",
             "tversky",
             "sorensen_dice",
             "substring_set",
             "substring_sort",
             "overlap",
             "ngram"
           ]

    assert whole_string == [
             "bag_distance",
             "levenshtein",
             "jaro_winkler",
             "jaccard",
             "tversky",
             "sorensen_dice"
           ]

    assert partial_string == ["substring_set", "substring_sort", "overlap", "ngram"]
  end

  test "requesting a subset of algorithms in the options results in expected subset of algorithms" do
    a = ["metaphone", "bag_distance", "substring_sort"]
    a_set = algorithms(algorithms: a)
    b = ["overlap", "substring_double_metaphone"]
    b_set = algorithms(algorithms: b)

    assert a_set == a
    assert b_set == b
  end

  test "comparing two exact strings returns all 1.0 values" do
    results = compare("Alice", "Alice", Akin.algorithms([]))

    assert Enum.all?(results, fn {_k, v} -> v == 1.0 end)
  end

  test "comparing a name against a list of names in which that name appears, returns a match" do
    assert match_names("alice", ["alice"]) == ["alice"]
  end

  test "comparing a name with initials matches names with all of those initials match" do
    names_to_match = ["a liddell"]
    results = match_names("a p liddell", names_to_match)

    expected = names_to_match -- ["alice b liddell"]

    assert Enum.all?(results, fn r -> r in expected end)
  end
end
