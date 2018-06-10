require 'optparse'
require 'yaml'

module UncomplicatedArchivist
  class Parser
    attr_accessor :options, :grab_collections

    def initialize(options = {})
      @options = options
      config_location = @options[:config_location] = ENV['CONFIG_LOCATION'] || 'config/uncomplicated-archivist.yml'

      if File.file? @options[:config_location]
        @options = YAML.load_file(config_location)
      end

      @options.merge!(YAML.load_file('local_defaults.yml')) if File.file?('local_defaults.yml')

      OptionParser.new do |opts|
        # opts.banner = 'Usage: example.rb [options]'
        opts.on('-v') do |v|
          options[:verbose] = true
        end
      end.parse!

      @options[:collection_config_location] = @options[:collection_config_location] || ENV['COLLECTION_CONFIG_LOCATION'] || 'config/uncomplicated-archivist-collections.yml'

      raise "No Collection File at @options[:collection_config_location]" unless File.file? @options[:collection_config_location]

      @grab_collections = YAML.load_file(@options[:collection_config_location])

      @options[:git_local_location] = @options[:git_local_location] || ENV['GIT_LOCAL_LOCATION'] || "#{ENV['HOME']}/.uncomplicated-archivist"

      puts @options if options[:verbose]
      puts @grab_collections if options[:verbose]
    end
  end
end
