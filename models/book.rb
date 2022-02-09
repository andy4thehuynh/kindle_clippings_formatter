require_relative "highlight"

class Book < Ohm::Model
  attribute :title

  collection :highlights, :Highlight
end
