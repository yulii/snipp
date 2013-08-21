module Snipp
  module ActionViewExtension

    def self.included(base)
      # Include HTML meta module
      base.send :include, Snipp::Markup::Html

      # Include markup module
      name = "#{Snipp.config.markup}".camelize
      raise NotImplementedError, "#{name} is invalid. Specify correct Snipp.config.markup." unless Snipp::Markup.const_defined? name
      base.send :include, Snipp::Markup.const_get(name)
    end

  end
end
