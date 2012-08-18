require 'digest/md5'

class ObjectCache
  def initialize(cache)
    @cache = cache
  end

  def expire(raw_key)
    return unless @cache

    @cache.delete key(raw_key)
  end

  def fetch(raw_key, ttl)
    return yield unless @cache

    @cache.fetch key(raw_key), ttl do
      yield
    end
  end

private

  # Hash it since memcache has limits on key names.
  def key(raw_key)
    Digest::MD5.hexdigest(raw_key)
  end
end
