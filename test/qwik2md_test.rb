require 'test_helper'

class Qwik2mdTest < Minitest::Test
  def test_hoge
    expected = <<~HTML.chomp
      <h2
      >h2</h2
      ><h3
      >h3</h3
      >
    HTML

    actual = Qwik2md.convert(<<~QWIK)
      * h2
      ** h3
    QWIK

    assert_equal expected, actual
  end
end
