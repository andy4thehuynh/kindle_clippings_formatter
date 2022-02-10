require_relative "book"

class Highlight < Ohm::Model
  attribute :title
  attribute :location
  attribute :text

  reference :book, Book

  # Example strings to pattern match to retrieve the location:
  # - Your Highlight on page 279 | Location 5557-5561 | Added on Sunday, August 22, 2021 9:13:10 PM
  # - Your Highlight on Location 375-375 | Added on Monday, December 4, 2017 1:29:51 PM
  def display_location
    return "" if location.nil? || location.strip.empty?

    your_highlights = location.match(%r{(?=.*(page.*Location.*))(?(1).*?\|)}) || location.match(%r{(?=.*(Location.*))(?(1).*?- Your Highlight on)})
    your_highlights.post_match.match(%r{(?=.*(.*Location))(?(1).*?\d+-\d+)}).to_s.strip
  end
end
