require 'io/console'
require 'json'

# Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
%w[parser logging smalllibrarian].each do |r|
  require_relative r
end

module SmallLibrarian
  class Cli
    def initialize()
      @parser = SmallLibrarian::Parser.new()
      @options = @parser.options
      @small_librarian = SmallLibrarian::Librarian.new(@parser.options, @parser.grab_collections)
    end
  end
end
