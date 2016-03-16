require "qwik2md/version"
require "qwik/parser-emode"
require "qwik/tokenizer"
require "qwik/parser"
require 'qwik/wabisabi-format-xml'
require 'reverse_markdown'
require 'qwik/action'
require 'qwik/loadlib'

require 'ostruct'

Qwik::LoadLibrary.load_libs_here('qwik/act-*')

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
      action = Qwik::Action.new
      action.init(OpenStruct.new(test: true), nil, nil, nil)
      action.instance_eval do
        @site = Object.new
        def @site.resolve_all_ref(tree)
          tree
        end
      end
      tree = action.resolve_all_plugin(tree)
      tree.format_xml
    end
  end
end
