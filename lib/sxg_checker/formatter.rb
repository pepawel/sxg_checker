module SxgChecker
  class Formatter
    def resource(resource)
      icon = icons.fetch(resource.status)
      "#{icon} #{resource.url}"
    end

    attr_reader :icons

    private

    def initialize(icons = {
          ok: '✓',
          missing: '?',
          invalid: 'x',
          parsing_error: '!',
          links_mismatch: '~',
          integrity_mismatch: '≠'
        })
      @icons = icons
    end
  end
end