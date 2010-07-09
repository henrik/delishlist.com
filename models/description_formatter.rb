require "rubygems"
require "rack"

class DescriptionFormatter
  
  CURRENCY_SYMBOL_RE = /[¢£$¥€]/u
  CURRENCY_TLA_RE    = /[A-Z]{3}/
  NUMBER_RE          = /\d(?:[., ]?\d)*/
  
  AUTO_LINK_RE = %r{
          ( https?:// | www\. )
          [^\s<]+
        }x
  BRACKETS = { ']' => '[', ')' => '(', '}' => '{' }

  
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def format
    # The order is important, as we must escape HTML before adding markup.
    return unless @description
    escape_html
    mark_up_quotes
    mark_up_price
    autolink
    @description
  end
  
  def autolink
    # From Rails 3, http://gist.github.com/358471.
    @description.gsub!(AUTO_LINK_RE) do
      href = $&
      punctuation = []
      left, right = $`, $'
      # detect already linked URLs and URLs in the middle of a tag
      if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
        # do not change string; URL is already linked
        href
      else
        # don't include trailing punctuation character as part of the URL
        while href.sub!(/[^\w\/-]$/, '')
          punctuation.push $&
          if opening = BRACKETS[punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
            href << punctuation.pop
            break
          end
        end

        link_text = href
        href = 'http://' + href unless href =~ %r{^[a-z]+://}i
        
        %{<a href="#{Rack::Utils.escape_html(href)}">#{Rack::Utils.escape_html(link_text)}</a>} + punctuation.reverse.join('')
      end
    end

  end
  
  def escape_html
    @description = Rack::Utils.escape_html(@description)
  end

  def mark_up_quotes
    @description.gsub!(/(&quot;|")\s*[^a-z].*?[!?.]\s*\1/) { "<q>#{$&}</q>" }
  end

  def mark_up_price
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
    
    def assert_escape_html(expected, input)
      df = DescriptionFormatter.new(input)
      df.escape_html
      assert_equal(expected, df.description)
    end
    
    def test_format
      assert_equal '<strong class="price">$123.45 USD</strong>. &lt;script&gt;evil&lt;/script&gt; <a href="http://x.com/foo?bar=baz#boink">http://x.com/foo?bar=baz#boink</a>. <q>&quot;Expensive.&quot;</q>',
                   DescriptionFormatter.new('$123.45 USD. <script>evil</script> http://x.com/foo?bar=baz#boink. "Expensive."').format
    end
    
    def test_escape_html
      assert_escape_html('foo', 'foo')
      assert_escape_html('&lt;foo&gt;&quot;bar&#39;s', %{<foo>"bar's})
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
