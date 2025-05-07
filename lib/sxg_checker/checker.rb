require 'uri'
require 'http'
require 'parallel'

module SxgChecker
  class Checker
    def call(document_url)
      url = cacheify_document_url(document_url)
      response = fetch_sxg(url)
      return Document.new(url, :missing) unless response

      sxg = extract_sxg(response.body)
      return Document.new(url, :parsing_error) unless sxg

      return Document.new(url, :invalid) unless sxg.fetch('Valid') == true

      fresh_cached = extract_links(response.headers['Link'])
      fresh_integrity = extract_integrity(sxg.fetch('ResponseHeaders').fetch('Link', [""]))
      return Document.new(url, :links_mismatch) if fresh_cached.keys.sort != fresh_integrity.keys.sort

      cached_integrity = fresh_integrity.map do |fresh, integrity|
        cached = fresh_cached.fetch(fresh)
        [cached, integrity]
      end.to_h

      subresources = mapper.call(cached_integrity, in_threads: [cached_integrity.size, 20].min) do |cached, integrity|
        status = check_subresource(cached, integrity)
        Subresource.new(cached, status)
      end

      Document.new(url, :ok, subresources)
    end

    private

    def check_subresource(url, expected_integrity)
      response = fetch_sxg(url)
      return :missing unless response

      sxg = extract_sxg(response.body)
      return :parsing_error unless sxg

      actual_integrity = sxg.fetch('HeaderIntegrity')
      return :integrity_mismatch unless actual_integrity == expected_integrity

      return :invalid unless sxg.fetch('Valid') == true

      :ok
    end

    def fetch_sxg(url)
      response = HTTP.headers(accept: "application/signed-exchange;v=b3").get(url)
      return nil unless response.content_type.mime_type == 'application/signed-exchange'

      response
    end

    def extract_links(link_header)
      link_header.to_s.split(',').
        select { _1 =~ /application\/signed-exchange;v=b3/ }.
        map { _1 =~ /^<(.+)>.+anchor="(.+)"/; [$2, $1] }.
        to_h
    end

    def extract_integrity(link_headers)
      link_headers.
        map { _1.to_s.split(',') }.
        flatten.
        select { _1 =~ /rel=allowed-alt-sxg/ }.
        map { _1 =~ /^<(.+)>.+header-integrity="(.+)"/; [$1, $2] }.
        to_h
    end

    def extract_sxg(body)
      Tempfile.open('sxg', :encoding => 'ascii-8bit') do |file|
        file.write body
        file.flush
        parse_sxg_file file.path
      end
    end

    def parse_sxg_file(path)
      command = "#{tool} -json -verify -i #{path}"
      result = `#{command} 2> /dev/null`
      return nil if result.empty?
      JSON.parse(result)
    end

    def cacheify_document_url(url)
      host = URI.parse(url).host.gsub('.', '-')
      "https://#{host}.webpkgcache.com/doc/-/s/#{url.sub('https://', '')}"
    end

    attr_reader :tool, :mapper

    def initialize(mapper: Parallel.method(:map),
                   tool: "#{ENV['HOME']}/go/bin/dump-signedexchange")
      @mapper = mapper
      @tool = tool
    end
  end
end