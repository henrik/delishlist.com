# encoding: utf-8

class TitleImprover

  TRANSLATIONS = [
    [/Amazon.com: (.+) \([A-Z\d]{10,13}\): (.+?): Books/, '\2 - \1'],
    [/Amazon.com: (.+): Books: ([^:]+)/, '\2 - \1'],
    [/Amazon.com: (.+)/, '\1'],
    [/(.*?) \(\d+\) av (.*?) - Adlibris bokhandel\.?/i, '\2 - \1'],
    [/(.+) - Bokus bokhandel/, '\1'],
    [/Sephora: (.+)/, '\1'],
    [/Juicy Couture \|(?: [^|]+ \|)* (.+)/, '\1'],
  ]

  def self.improve_title(title)
    TRANSLATIONS.each do |from, unto|
      return title.sub(from, unto) if title.match(/\A#{from}\z/)
    end
    title
  end

end

if $0 == __FILE__

  require "test/unit"

  class TitleImproverTest < Test::Unit::TestCase

    def test_transformations
      expectations = {
        "Some - Random - Title" => "Some - Random - Title",
        "Amazon.com: Bla: Bla" => "Bla: Bla",
        "Amazon.com: My Book: Books: An Author" => "An Author - My Book",
        "Amazon.com: My Book (1234567890): An Author: Books" => "An Author - My Book",
        "Amazon.com: My Book: Subtitle (1234567890): An Author: Books" => "An Author - My Book: Subtitle",
        "My Book (01234567) av En Författare - Adlibris bokhandel" => "En Författare - My Book",
        "Författare - Bok - Bokus bokhandel" => "Författare - Bok",
        "Sephora: Perfume" => "Perfume",
        "Juicy Couture | Thing" => "Thing",
        "Juicy Couture | Cat | Cat | Thing" => "Thing",
      }
      expectations.each do |from, unto|
        assert_equal unto, TitleImprover.improve_title(from)
      end
    end

  end
end
