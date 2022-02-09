require_relative "book"

class Highlight < Ohm::Model
  attribute :title
  attribute :location
  attribute :text

  reference :book, Book

  # include Comparable

  # attr_reader :starting_location

  # def starting_location
  #   str_beg = "- Your Highlight on Location"
  #   str_end = " "

  #   @starting_location, _ = raw_location.split(str_beg).last.split(str_end).first.split("-")
  # end

  # def <=>(other)
  #   starting_location <=> other.staring_location
  # end
end
