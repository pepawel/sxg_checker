module SxgChecker
  class Subresource
    attr_reader :url, :status

    private

    def initialize(url, status)
      @url = url
      @status = status
    end
  end
end