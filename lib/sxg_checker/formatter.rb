module SxgChecker
  class Formatter
    def call(resource)
      icon = icons.fetch(resource.status)
      "#{icon} #{resource.url}"
    end

    private

    attr_reader :icons

    def initialize(icons = {
          ok: '✓',
          missing: '?',
          parsing_error: '!',
          invalid: 'x',
          links_mismatch: '~',
          integrity_mismatch: '≠'
        })
      @icons = icons
    end
  end
end