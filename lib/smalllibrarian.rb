require 'fileutils'
require 'logger'

module SmallLibrarian
  class Librarian
    include Logging
    def initialize(options = {}, grab_collections = {})
      @options = options
      @grab_collections = grab_collections
      start
    end

    def start
      file_sets = @grab_collections.select { |group| group[:source] == 'file' }
      process_file_sets file_sets
    end

    def process_file_sets(sets)
      sets.each do |set|
        set[:grabs].each do |grab|
          grab[:files].each do |source, destination|
            logger.warn "#{source} to #{destination}" if @options[:verbose]
            if source =~ /\/\*/ 
              raise "#{destination} not a directory" unless File.directory?(destination)
              FileUtils.cp_r Dir.glob(source), destination
            else
              logger.warn "warning file exists #{destination}" if File.file?(destination)
              # strip traling slash
              if File.directory?(destination) and File.file?("#{destination}/#{File.basename(source)}")
                logger.warn "warning file exists #{destination}/#{File.basename(source)}"
              end
              FileUtils.cp source, destination
            end
          end
        end
      end
    end

  end
end
