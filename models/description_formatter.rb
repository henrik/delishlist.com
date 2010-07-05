class DescriptionFormatter
  
  CURRENCY_SYMBOL_RE = /[¢£$¥€]/u
  CURRENCY_TLA_RE    = /[A-Z]{3}/
  NUMBER_RE          = /\d(?:[., ]?\d)*/
  
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def format
    # It's important to markup quotes first, since HTML attributes add quotes.
    mark_up_quotes
    mark_up_price
    @description
  end

  def mark_up_quotes
    if @description
      @description.gsub!(/"\s*[^a-z].*?[!?.]\s*"/) { "<q>#{$&}</q>" }
    end
  end

  def mark_up_price
    if @description
      @description.gsub!(/
          (^|\W)  # \b doesn't work as non-word characters (e.g. "$" and " ") don't have word boundaries against each other.
          (~?(?:
            #{CURRENCY_SYMBOL_RE}?\ ?#{NUMBER_RE}\ ?#{CURRENCY_TLA_RE} |  # Symbol optional, number and TLA.
            #{CURRENCY_SYMBOL_RE}\ ?#{NUMBER_RE} |                        # Symbol and number.
            #{NUMBER_RE}\ ?#{CURRENCY_SYMBOL_RE} |                        # Number and symbol.
            #{CURRENCY_TLA_RE}\ ?#{NUMBER_RE}                             # TLA and number.
          ))
          ($|\W)
        /ux) do
        %[#{$1}<strong class="price">#{$2}</strong>#{$3}]
      end
    end
  end

end


if __FILE__ == $0
  require "test/unit"
  
  class DescriptionFormatterTest < Test::Unit::TestCase
    
    def assert_marked_up_quotes(expected, input)
      df = DescriptionFormatter.new(input)
      df.mark_up_quotes
      assert_equal(expected, df.description)
    end
    
    def assert_marked_up_price(expected, input)
      df = DescriptionFormatter.new(input)
      df.mark_up_price
      assert_equal(expected, df.description)
    end
    
    def test_format
      assert_equal '<strong class="price">$123.45 USD</strong>. <q>"Expensive."</q>',
                   DescriptionFormatter.new('$123.45 USD. "Expensive."').format
    end

    def test_mark_up_quotes
      assert_marked_up_quotes('foo bar baz', 'foo bar baz')
      assert_marked_up_quotes('foo "bar" baz', 'foo "bar" baz')
      assert_marked_up_quotes('foo "Bar" baz', 'foo "Bar" baz')
      assert_marked_up_quotes('foo <q>"Bar."</q> baz', 'foo "Bar." baz')
    end
    
    def test_mark_up_price
      assert_marked_up_price(%{foo bar baz}, %{foo bar baz})

      assert_marked_up_price('<strong class="price">$123</strong> foo', '$123 foo')
      assert_marked_up_price('foo <strong class="price">$123</strong> baz', 'foo $123 baz')
      assert_marked_up_price('foo <strong class="price">$123</strong>', 'foo $123')
      assert_marked_up_price('<strong class="price">$123</strong>', '$123')

      assert_marked_up_price('<strong class="price">$1,234,567.89</strong>', '$1,234,567.89')

      assert_marked_up_price('<strong class="price">$123USD</strong>', '$123USD')
      assert_marked_up_price('<strong class="price">€ 123 EUR</strong>', '€ 123 EUR')
      assert_marked_up_price('<strong class="price">123 SEK</strong>', '123 SEK')
      assert_marked_up_price('<strong class="price">123£</strong>', '123£')
      assert_marked_up_price('<strong class="price">CAD 123</strong>', 'CAD 123')

      assert_marked_up_price('<strong class="price">~$123</strong>', '~$123')
    end
    
  end
  
end
