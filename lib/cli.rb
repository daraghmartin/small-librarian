require 'io/console'
require 'json'

# Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
%w[parser logging uncomplicatedarchivist].each do |r|
  require_relative r
end

module UncomplicatedLibrarian
  class Cli
    def initialize()
      @parser = UncomplicatedLibrarian::Parser.new()
      @options = @parser.options
      @small_librarian = UncomplicatedLibrarian::Librarian.new(@parser.options, @parser.grab_collections)
    end
  end
end
