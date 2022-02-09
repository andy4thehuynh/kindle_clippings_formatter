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


Ohm.redis = Redic.new("redis://127.0.0.1:6379")


Cuba.define do
  persist_session!

  on root do
    render("index", locals: { books: Book.all.sort_by(:title, order: "ALPHA") })
  end

  on "book/:id" do |id|
    book = Book[id]
    render("books/show", locals: { book: book })
  end
end

# File.open(File.expand_path("~/Downloads/new_target.txt"), "wb") { |f| f.write(contents.join())  }

# binding.pry
# 
# contents = blocks.map { |block| [block[0].prepend("### "), block[1]].join() }
# contents.shift
