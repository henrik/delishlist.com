class User
  attr_reader :name
  
  def initialize(name)
    if name.to_s.match(/\Au:(.+)/)
      @name = $1
      @pinboard = true
    else
      @name = name
      @pinboard = false
    end
  end

  def pinboard?
    @pinboard
  end

  def parser
    klass = pinboard? ? Pinboard : Delicious
    klass.new(name, "wishlist")
  end

  def possessive
    genitive = name[-1,1] == 's' ? %{’} : %{’s}
    name + genitive
  end
  alias_method :s, :possessive  # "#{@user.s} delishlist"!

  def to_s
    name
  end

end
