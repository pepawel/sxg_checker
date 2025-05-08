module SxgChecker
  class Subresource
    include Comparable

    attr_reader :url, :status

    def fresh_url
      @fresh_url ||= url.sub(/^.+\/s\//, 'https://')
    end

    def <=>(o)
      fresh_url <=> o.fresh_url
    end

    private

    def initialize(url, status)
      @url = url
      @status = status
    end
  end
end