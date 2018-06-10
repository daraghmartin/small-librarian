require 'io/console'
require 'json'
require 'git'

# Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
%w[parser logging uncomplicatedarchivist].each do |r|
  require_relative r
end

module UncomplicatedArchivist
  class Cli
    def initialize()
      @parser = UncomplicatedArchivist::Parser.new()
      @options = @parser.options
      @small_librarian = UncomplicatedArchivist::Librarian.new(@parser.options, @parser.grab_collections)
    end
  end
end
