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

  def test_image
    expected = <<~MD
       [![a.jpg](.theme/i/broken.gif)
      a.jpg](Page1.files/a.jpg)
    MD

    actual = Qwik2md.convert(<<~QWIK, filename: 'Page1').gsub(/ +\n/, "\n")
      {{file(a.jpg)}}
    QWIK

    assert_equal expected, actual
  end
end
