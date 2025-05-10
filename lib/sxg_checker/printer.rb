module SxgChecker
  class Printer
    def call(document)
      puts "#{icon(document)} #{document.url}"
      document.subresources.sort.each do |subresource|
        puts "#{icon(subresource)}   #{subresource.url}"
      end
    end

    attr_reader :icons

    private

    def icon(resource)
      icons.fetch(resource.status)
    end

    def initialize(icons = {
      ok: "✓",
      missing: "?",
      invalid: "x",
      parsing_error: "!",
      links_mismatch: "~",
      integrity_mismatch: "≠"
    })
      @icons = icons
    end
  end
end
