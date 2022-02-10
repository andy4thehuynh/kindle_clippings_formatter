require_relative "highlight"

class Book < Ohm::Model
  attribute :title

  collection :highlights, :Highlight
end

# Follows the Null Object Pattern in case a book is missing
class NullBook
  def id
    0
  end

  def title
    "No Title"
  end

  def highlights
    []
  end
end
