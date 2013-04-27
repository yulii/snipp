module Snipp
  class Railtie < ::Rails::Railtie
    initializer :snipp do |app|
      Snipp::Hooks.init
    end
  end
end
