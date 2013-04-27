module Snipp
end

require 'snipp/config'
require 'snipp/markups/microdata'
require 'snipp/helpers/action_view_extension'
require 'snipp/hooks'

if defined? Rails
  require 'snipp/railtie'
  require 'snipp/engine'
end
