# -*- coding: utf-8 -*-
#
module SyndicatePlusApi
  # Provides a cache for API requests.
  #
  # I've tried to use rest-client-components with rack-cache, but the Syndicate
  # Plus API returns +Cache-Control: private+ without expiration headers. This
  # is a little less robust (in case we'd also do updates from the API), but works.
  class Cache
    # Returns cached value of block using Rails cache.
    #
    # When Rails is not defined, the block is always called.
    # When there is no cache {Configuration}, the block is always called.
    def self.with_cache(keys)
      defined? Rails or return yield
      Configuration.cache or return yield

      value = Configuration.cache.read(keys)
      if value.nil?
        value = yield
	keys = keys.merge(type: 'SyndicatePlusApi::Cache')
	Configuration.cache.write(keys, value, expires_in: Configuration.cache_expires_in)
      end

      value
    end
  end
end
