class ObjectCache
  
  DEFAULT_TTL = 5 * 60  # 5 minutes
  DEFAULT_ROOT = "/tmp/cache"
  
  def initialize(key, opts={})
    @key  = key
    @ttl  = opts[:ttl]  || DEFAULT_TTL
    @root = opts[:root] || DEFAULT_ROOT
    FileUtils.mkdir_p(@root)
  end
  
  def self.get_or_set(key, opts={})
    cache = new(key, opts)
    unless object = cache.get
      object = yield
      cache.set(object)
    end
    object
  end
  
  def get
    fresh? && File.open(path) { |f| Marshal.load(f) }
  end
  
  def set(value)
    File.open(path, 'w') { |f| Marshal.dump(value, f) }
  end
  
private

  def fresh?
    exist? && age <= @ttl
  end
  
  def age
    Time.now - File.mtime(path)
  end

  def exist?
    File.exist?(path)
  end

  def path
    @path ||= File.join(@root, @key)
  end
  
end
