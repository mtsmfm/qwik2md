require "qwik2md/version"
require "qwik/parser-emode"
require "qwik/tokenizer"
require "qwik/parser"
require 'qwik/wabisabi-format-xml'

module Qwik2md
  class << self
    def convert(qwik)
      if Qwik::EmodePreProcessor.emode?(qwik)
	       qwik = Qwik::EmodePreProcessor.preprocess(qwik)
      end
      tokens = Qwik::TextTokenizer.tokenize(qwik)
      tree = Qwik::TextParser.make_tree(tokens)
      tree.format_xml
    end
  end
end
