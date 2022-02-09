require "pry"

require "cuba"
require "cuba/contrib"
require "mote"
require "ohm"
require "ohm/contrib"
require "rack/protection"
require "scrivener"
require "scrivener_errors"
require "shield"

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Prelude
Cuba.plugin ScrivenerErrors::Helpers
Cuba.plugin Shield::Helpers

# Require all application files.
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

# Require all helper files.
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./filters/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie,
  key: "my_new_app",
  secret: 'foo'

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  root: "./public",
  urls: %w[/js /css /img]


# block_delimiter = "==========" 


Cuba.define do
  persist_session!

  on root do
    class Book
      attr_reader :title

      def initialize(title)
        @title = title
      end

      def create_highlight(title, location, text)
        highlights << Highlight.new(title, location, text)
      end

      def highlights
        @highlights ||= []
      end
    end

    class Highlight
      include Comparable

      attr_accessor :title, :raw_location, :text, :starting_location

      def initialize(title, raw_location, text)
        @title        = title
        @raw_location = raw_location
        @text         = text
        str_beg = "- Your Highlight on Location"
        str_end = " "

        @starting_location, @ending_location = raw_location.split(str_beg).last.split(str_end).first.split("-")
      end

      def <=>(other)
        starting_location <=> other.staring_location
      end
    end

    text = File.read(File.expand_path("~/Code/kindle_clippings_formatter/My Clippings.txt"))
    text = text.gsub!("\xEF\xBB\xBF", "")
    highlights = text.split("\r\n==========\r\n")

    book_titles = highlights.map { |h| h.split("\r\n") }.map(&:first).uniq


    books = book_titles.map do |title|
      Book.new(title)
    end

    highlights.map do |highlight|
      title, location, text = highlight.split("\r\n", 3)  

      books.each do |book|
        if book.title == title
          book.create_highlight(title, location, text)
        else
        end
      end 
    end
    binding.pry

    render("index", locals: { books: books, book_titles: book_titles })
  end
end

# File.open(File.expand_path("~/Downloads/new_target.txt"), "wb") { |f| f.write(contents.join())  }

# binding.pry
# 
# contents = blocks.map { |block| [block[0].prepend("### "), block[1]].join() }
# contents.shift
