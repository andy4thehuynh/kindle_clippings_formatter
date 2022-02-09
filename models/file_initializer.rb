require_relative "book"
require_relative "highlight"

class FileInitializer
  BOM_CHARS = "\xEF\xBB\xBF"
  FILEPATH = "~/Code/kindle_clippings_formatter/My Clippings.txt"

  def self.call
    text = File.read(File.expand_path(FILEPATH))
    text = text.gsub!(BOM_CHARS, "")
    highlights = text.split("\r\n==========\r\n")

    book_titles = highlights.map { |h| h.split("\r\n") }.map(&:first).uniq

    books = book_titles.map do |title|
      Book.create(title: title)
    end

    highlights.map do |highlight|
      title, location, text = highlight.split("\r\n", 3)

      books.each do |book|
        if book.title == title
          if book.save
            Highlight.create(title: title, location: location, text: text, book_id: book.id)
          end
        end
      end
    end
  end
end

# Book.all.sort_by(:title, order: "ALPHA")
