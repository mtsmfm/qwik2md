require "qwik2md/version"

require "qwik/parser-emode"
require "qwik/tokenizer"
require "qwik/parser"
require 'qwik/wabisabi-format-xml'
require 'qwik/action'
require 'qwik/loadlib'
require 'qwik/config'
require 'qwik/request'
require 'qwik/response'
require 'qwik/farm'
require 'qwik/test-module-path'

require 'webrick'
require 'logger'

require 'reverse_markdown'
require 'charlock_holmes'

Qwik::LoadLibrary.load_libs_here('qwik/act-*')

module Qwik2md
  class Action
    def initialize(dir, base)
      @dir = dir
      @base = base
    end

    def resolve_all_plugin(tree)
      action.resolve_all_plugin(tree)
    end

    private

    def action
      @action ||= Qwik::Action.new.tap do |action|
        action.init(config, memory, req, res)
        _site = site
        action.instance_eval {
          @site = _site;
        }
      end
    end

    def memory
      @memory ||= Qwik::ServerMemory.new(config).tap do |memory|
        logfile = File.join(@dir, '.test/testlog.txt')
        loglevel = WEBrick::Log::INFO
        logger = WEBrick::Log::new(logfile, loglevel)
        memory[:logger] = logger

        burylogfile = File.join(@dir, '.test/testburylog.txt')
        log = ::Logger.new(burylogfile)
        log.level = ::Logger::INFO
        memory[:bury_log] = log
      end
    end

    def site
      @site ||= memory.farm.get_site('test')
    end

    def req
      @req ||= Qwik::Request.new(config).tap do |req|
        req.base = @base
      end
    end

    def res
      @res ||= Qwik::Response.new(config)
    end

    def config
      @config ||= Qwik::Config.new.tap do |config|
        config.update(Qwik::Config::DebugConfig)
        config.update(Qwik::Config::TestConfig)

        %i(
          sites_dir
          grave_dir
          cache_dir
          etc_dir
          log_dir
        ).each do |key|
          config[key] = File.join(@dir, config[key])
        end

        config.sites_dir.path.check_directory
        config.grave_dir.path.check_directory
        config.cache_dir.path.check_directory
        config.etc_dir.path.check_directory
        config.log_dir.path.check_directory

        wwwdir = config.sites_dir.path + 'www'
        wwwdir.setup
        dir = config.sites_dir.path + 'test'
        dir.setup
      end
    end
  end

  class << self
    def convert(qwik_str, base:)
      Converter.new(qwik_str, base: base).convert
    end
  end

  class Converter
    def initialize(qwik_str, base:)
      detection = CharlockHolmes::EncodingDetector.detect(qwik_str)
      @qwik_str = CharlockHolmes::Converter.convert(qwik_str, detection[:encoding], 'UTF-8')
      @base = base
    end

    def convert
      Dir.mktmpdir do |dir|
        ReverseMarkdown.convert(to_html(dir))
      end
    end

    private

    def to_html(dir)
      str =
        if Qwik::EmodePreProcessor.emode?(@qwik_str)
           Qwik::EmodePreProcessor.preprocess(@qwik_str)
         else
           @qwik_str
        end

      tokens = Qwik::TextTokenizer.tokenize(str)
      tree = Qwik::TextParser.make_tree(tokens)
      action = Action.new(dir, @base)
      tree = action.resolve_all_plugin(tree)
      tree.format_xml
    end
  end
end
