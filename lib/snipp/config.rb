require 'active_support/configurable'

module Snipp

  def self.configure(&block)
    yield @config ||= Snipp::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :root_url, :markup, :html_meta_tags

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end

  configure do |config|
    config.markup         = :microdata
    config.html_meta_tags = {
      title:       '',
      description: '',
      keywords:    '',
      og: {
        site_name:   '',
        type:        'article',
        title:       '',
        description: '',
        image:       ''
      },
      author:      '',
      robots:      ['index,follow', 'noodp', 'noydir'],
      viewport:    'width=device-width'
    }
  end
end
