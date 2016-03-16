require 'test_helper'

class Qwik2mdTest < Minitest::Test
  def test_convert
    expected = <<~MD
      ## Jan 1, 1970 From: example@e...

      ## h2

      ### h3
    MD

    actual = Qwik2md.convert(<<~QWIK)
      {{mail(example@example.com,1)
      * h2

      ** h3
      }}
    QWIK

    assert_equal expected, actual
  end
end
