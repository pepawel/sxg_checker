require "optparse"

module SxgChecker
  class Cli
    def call(argv)
      argv = argv.dup # argv will be changed
      options = {
        subresources: true,
        errors_only: false,
        dump_binary: DUMP_BINARY
      }

      parser = OptionParser.new do |opts|
        opts.on("-h", "--help") do
          show_usage
          return 0
        end

        opts.on("-v", "--version") do
          puts VERSION
          return 0
        end

        opts.on("-n", "--no-subresources") do
          options[:subresources] = false
        end

        opts.on("-e", "--errors-only") do
          options[:errors_only] = true
        end

        opts.on("-d", "--dump-binary=PATH", String) do |path|
          options[:dump_binary] = path
        end
      end

      if argv.empty?
        print_error "command required, use -h for help"
        return 1
      end

      begin
        # Parse options, leaving the command and URLs in argv
        parser.parse!(argv)
      rescue OptionParser::InvalidOption => e
        print_error e.message
        return 1
      end

      command = argv.shift
      urls = argv

      checker = SxgChecker::Checker.new(tool: options[:dump_binary])

      case command
      when "warm"
        if urls.empty?
          print_error "no URLs provided for warming"
          return 1
        end

        urls.each do |url|
          checker.warm_cache(url)
        end
        0
      when "validate"
        if urls.empty?
          print_error "no URLs provided for validation"
          return 1
        end

        urls.each do |url|
          document = checker.validate(url, subresources: options[:subresources])
          printer.call(document) unless document.ok? && options[:errors_only]
        end
        0
      else
        print_error "unknown command '#{command}'"
        1
      end
    rescue Error => e
      print_error e.message
      1
    end

    private

    def print_error(message)
      puts "#{exe_name}: error: #{message}"
    end

    def show_usage
      puts "SXG Checker #{VERSION}"
      puts "  Queries the Google SXG cache for the presence of documents and their subresources."
      puts
      puts "Usage:"
      puts "  #{exe_name} [global options]"
      puts "  #{exe_name} warm <URLs>"
      puts "  #{exe_name} validate [validate options] <URLs>"
      puts
      puts "Global options:"
      puts "  -h, --help             Show this help message and exit"
      puts "  -v, --version          Show version information and exit"
      puts
      puts "Commands:"
      puts "  warm                   Warm the cache for specified URLs"
      puts "  validate               Validate SXG documents and their subresources"
      puts
      puts "Validate options:"
      puts "  -n, --no-subresources  Skip validating subresources (validate documents only)"
      puts "  -e, --errors-only      Display only errors (skip successfully validated URLs)"
      puts "  -d, --dump-binary=PATH Path to dump-signedexchange binary"
      puts "                         Default: #{DUMP_BINARY}"
      puts
      show_statuses
      puts
      puts "Examples:"
      puts "  #{exe_name} warm https://example.com/page1"
      puts "  #{exe_name} validate -n -e https://example.com/page1 https://another.com"
    end

    def show_statuses
      puts "Validation status indicators:"
      printer.icons.map do |status, icon|
        puts "  #{icon} #{status.to_s.tr("_", " ").capitalize}"
      end
    end

    attr_reader :exe_name, :printer, :checker, :default_dump_binary

    def initialize(exe_name)
      @exe_name = exe_name
      @printer = SxgChecker::Printer.new
    end
  end
end
