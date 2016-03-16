require 'test_helper'

class Qwik2mdTest < Minitest::Test
  def test_convert
    expected = <<~MD
      ## h2

      ### h3
    MD

    actual = Qwik2md.convert(<<~QWIK)
      * h2

      ** h3
    QWIK

    assert_equal expected, actual
  end
end
