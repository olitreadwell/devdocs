module Docs
  class Request < Typhoeus::Request
    include Instrumentable

    DEFAULT_OPTIONS = {
      followlocation: true,
      headers: { 'User-Agent' => 'DevDocs' }
    }

    def self.run(*args, &block)
      request = new(*args)
      request.on_complete(&block) if block
      request.run
    end

    # The ResponseCache the request reads from and writes to, if any.
    attr_reader :cache

    def initialize(url, options = {})
      options = DEFAULT_OPTIONS.merge(options)
      # The merge above is shallow, so passing :headers would otherwise drop
      # the default ones, User-Agent included.
      options[:headers] = DEFAULT_OPTIONS[:headers].merge(options[:headers] || {})
      @cache = options.delete(:cache)
      super url.to_s, options
    end

    def cached_response
      cache.get(self) if cache
    end

    def response=(value)
      if value
        value.extend Response
        cache.set(self, value) if cache
      end
      super
    end

    def run
      instrument 'response.request', url: base_url do |payload|
        cached = cached_response
        response = cached ? finish(cached) : super
        payload[:response] = response
        response
      end
    end
  end
end
