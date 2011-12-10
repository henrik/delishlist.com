# Amazon::Referralizer
# by Henrik Nyh <http://henrik.nyh.se> 2010-07-05 under the MIT license.

# Add your Amazon Associates referral id to an Amazon URL, replacing any that were already there.
#
# E.g.:
#
#   Amazon::Referralizer.referralize("http://amazon.co.uk/o/ASIN/B00168PO6U?tag=evil-20", "good-20")
#   # => "http://amazon.co.uk/o/ASIN/B00168PO6U?tag=good-20"
#

class Amazon
  class Referralizer
    ASIN_RE = /[A-Z0-9]{10}/
    REFERRAL_ID_RE = /\w+-\d\d/
  
    def self.referralize(url, tag)
      url = url.to_s

      if url.match(%r{^https?://(.+\.)?(amazon\.|amzn\.com\b)}i)
        url.sub!(%r{\b(#{ASIN_RE})\b(/#{REFERRAL_ID_RE}\b)?}, "\\1")
        url.gsub!(/&tag=#{REFERRAL_ID_RE}\b/, '')
        url.gsub!(/\?tag=#{REFERRAL_ID_RE}\b/, '?')
        url.sub!(/\?$/, '')
        url.sub!(/\?&/, '?')
        separator = url.include?("?") ? "&" : "?"
        [url, "tag=#{tag}" ].join(separator)
      else
        url
      end
    end

  end
end


if __FILE__ == $0
  require "test/unit"
  
  class AmazonReferralizerTest < Test::Unit::TestCase

    def assert_conversion(expected_url, input_url)
      assert_equal(expected_url, Amazon::Referralizer.referralize(input_url, "test-20"))
    end
    
    def test_url_formats
      assert_conversion "http://amazon.com/gp/product/B00168PO6U?tag=test-20",
                        "http://amazon.com/gp/product/B00168PO6U"
      assert_conversion "http://amazon.com/gp/product/B00168PO6U/?tag=test-20",
                        "http://amazon.com/gp/product/B00168PO6U/"
      assert_conversion "http://amazon.com/exec/obidos/tg/detail/-/B00168PO6U?tag=test-20",
                        "http://amazon.com/exec/obidos/tg/detail/-/B00168PO6U"
      assert_conversion "http://amazon.com/o/ASIN/B00168PO6U?tag=test-20",
                        "http://amazon.com/o/ASIN/B00168PO6U"
      assert_conversion "http://amazon.com/dp/B00168PO6U?tag=test-20",
                        "http://amazon.com/dp/B00168PO6U"
    end
    
    def test_international
      assert_conversion "http://amazon.co.uk/o/ASIN/B00168PO6U?tag=test-20",
                        "http://amazon.co.uk/o/ASIN/B00168PO6U"
      assert_conversion "http://amazon.de/o/ASIN/B00168PO6U?tag=test-20",
                        "http://amazon.de/o/ASIN/B00168PO6U"
    end
    
    def test_short
      assert_conversion "http://amzn.com/B00168PO6U?tag=test-20",
                        "http://amzn.com/B00168PO6U"
    end
    
    def test_keep_ref
      assert_conversion "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?tag=test-20",
                        "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp"
    end
    
    def test_replace_other_tag_in_path
      assert_conversion "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?tag=test-20",
                        "http://www.amazon.com/dp/B00168PO6U/evil-20/ref=cm_sw_su_dp"
    end
    
    def test_query_string
      assert_conversion "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?tag=test-20",
                        "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?tag=evil-20"
      assert_conversion "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?one=1&two=2&tag=test-20",
                        "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?one=1&tag=evil-20&two=2"
      assert_conversion "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?one=1&two=2&tag=test-20",
                        "http://www.amazon.com/dp/B00168PO6U/ref=cm_sw_su_dp?tag=evil-20&one=1&two=2"
    end
  
  end

end
