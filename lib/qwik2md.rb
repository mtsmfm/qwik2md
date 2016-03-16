require "qwik2md/version"
require "qwik/parser-emode"
require "qwik/tokenizer"
require "qwik/parser"
require 'qwik/wabisabi-format-xml'
require 'reverse_markdown'

module Qwik2md
  class << self
    def convert(qwik_str)
      Converter.new(qwik_str).convert
    end
  end

  class Converter
    def initialize(qwik_str)
      @qwik_str = qwik_str
    end

    def convert
      ReverseMarkdown.convert(to_html)
    end

    private

    def to_html
      str =
        if Qwik::EmodePreProcessor.emode?(@qwik_str)
           Qwik::EmodePreProcessor.preprocess(@qwik_str)
         else
           @qwik_str
        end

      tokens = Qwik::TextTokenizer.tokenize(str)
      tree = Qwik::TextParser.make_tree(tokens)
      tree.format_xml
    end
  end
end
