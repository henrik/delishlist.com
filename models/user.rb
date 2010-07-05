class User
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
    
  def delicious_url
    "http://delicious.com/#{name}"
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
