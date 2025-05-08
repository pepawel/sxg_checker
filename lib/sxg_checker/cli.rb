module SxgChecker
  class Cli
    def call(url)
      return show_usage if url.nil? || url == "-h" || url == "--help"

      document = checker.call(url)
      resources = [document] + document.subresources.sort
      resources.each do |resource|
        puts formatter.resource(resource)
      end
    rescue Error => e
      puts "#{exe_name}: error: #{e.message}"
      exit 1
    end

    private

    def show_usage
      puts "SXG Checker v#{VERSION}"
      puts "  Checks the Google SXG cache for the presence of a document and its subresources."
      puts
      puts "Usage:"
      puts "  #{exe_name} <URL>"
      puts
      puts "Example:"
      puts "  #{exe_name} https://www.yourwebsite.com/your-page"
      puts
      puts "Environment variables:"
      puts "  DSXG_PATH - path to dump-signedexchange binary (default: #{checker.default_tool})"
      puts
      show_statuses
    end

    def show_statuses
      puts "Possible statuses:"
      formatter.icons.map do |status, icon|
        puts "  #{icon} #{status.to_s.tr("_", " ")}"
      end
    end

    attr_reader :exe_name, :formatter, :checker

    def initialize(exe_name)
      @exe_name = exe_name
      @formatter = SxgChecker::Formatter.new
      @checker = SxgChecker::Checker.new
    end
  end
end
