module SxgChecker
  class Subresource
    include Comparable

    attr_reader :url, :status

    def fresh_url
      @fresh_url ||= url.sub(/^.+\/s\//, "https://")
    end

    def <=>(other)
      fresh_url <=> other.fresh_url
    end

    def ok?
      status == :ok
    end

    private

    def initialize(url, status)
      @url = url
      @status = status
    end
  end
end
