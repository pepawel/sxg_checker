module SxgChecker
  class Document
    attr_reader :url, :status, :subresources

    private

    def initialize(url, status, subresources = [])
      @url = url
      @status = status
      @subresources = subresources
    end
  end
end