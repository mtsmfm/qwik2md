require 'test_helper'

class String
  def strip_heredoc
    min = scan(/^[ \t]*(?=\S)/).min
    indent = min ? min.size : 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end

class Qwik2mdTest < Minitest::Test
  def test_hoge
    expected = <<-HTML.strip_heredoc.chomp
      <h2
      >h2</h2
      ><h3
      >h3</h3
      >
    HTML

    actual = Qwik2md.convert(<<-QWIK.strip_heredoc)
      * h2
      ** h3
    QWIK

    assert_equal expected, actual
  end
end
