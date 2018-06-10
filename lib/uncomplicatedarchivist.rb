require 'fileutils'
require 'logger'
require 'git'

module UncomplicatedArchivist
  class Librarian
    include Logging
    def initialize(options = {}, grab_collections = {})
      @options = options
      @grab_collections = grab_collections
      start
    end

    def start
      file_sets = @grab_collections[:uncomplicated_archivist_collections].select { |group| group[:source] == 'file' }
      process_file_sets file_sets

      git_sets = @grab_collections[:uncomplicated_archivist_collections].select { |group| group[:source] == 'git' }
      process_git_sets git_sets
    end

    def check_dir_and_mkdir_if_not_exist(dir)
      return if File.directory?(dir)

      logger.info "making #{dir}"
      FileUtils.mkdir_p dir
    end

    def process_git_sets(sets)
      git_path = "#{@options[:git_local_location]}/git-local-location"

      check_dir_and_mkdir_if_not_exist git_path

      sets.each do |set|
        # #if exists then rebase
        g = nil
        working_dir ="#{git_path}/#{set[:local_name]}"
        
        if File.directory?(working_dir)
          # pull
          g = Git.open(working_dir, log: Logger.new(STDOUT))
          g.fetch
          g.pull
        else
          g = Git.clone(set[:repository], set[:local_name], {path: git_path, log: Logger.new(STDOUT)})
        end

        set[:grabs].each { |grab| get_files(grab[:files], working_dir) }
      end
    end

    def process_file_sets(sets)
      sets.each do |set|
        set[:grabs].each { |grab| get_files(grab[:files]) }
      end
    end

    def get_files(files, pre_path = Dir.pwd)
      files.each do |source, destination|
        logger.info "#{pre_path}/#{source} to #{destination}" if @options[:verbose]
        if source =~ /\/\*/ 
          raise "#{destination} not a directory" unless File.directory?(destination)
          FileUtils.cp_r Dir.glob("#{pre_path}/#{source}"), destination
        else
          logger.warn "warning file exists #{destination}" if File.file?(destination)
          # strip traling slash
          if File.directory?(destination) and File.file?("#{destination}/#{File.basename(source)}")
            logger.warn "warning file exists #{destination}/#{File.basename(source)}"
          end
          FileUtils.cp "#{pre_path}/#{source}", destination
        end
      end
    end

  end
end
