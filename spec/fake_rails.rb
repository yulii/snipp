require 'action_controller/railtie'
require 'action_view/railtie'

# config
app = Class.new Rails::Application
app.config.active_support.deprecation = :log
app.config.secret_token = "e65e0140352e39703c113b0ce30335e8"
app.config.generators do |g|
#  g.template_engine :haml
end
app.initialize!

# routing
ITEMTYPES  = [:index, :html, :breadcrumb, :geo]
#ACTION_NAME = lambda {|e| "action#{e}" }
app.routes.draw do

  ITEMTYPES.each do |e|
    get "/#{e}" => "snipp##{e}", as: e
  end

  # for Breadcumb
  get "/foods"                     => "snipp#breadcrumb", as: :foods
  get "/foods/fruits"              => "snipp#breadcrumb", as: :fruits
  get "/foods/fruits/:color"       => "snipp#breadcrumb", as: :fruits_color
  get "/foods/fruits/:color/:name" => "snipp#breadcrumb", as: :food

#  scope "/admin" ,:module=>'admin'      ,as: :admin do
#    10.times do |e|
#      get "/#{ACTION_NAME.call(e)}" => "snipp##{ACTION_NAME.call(e)}"
#    end
#  end
end

# controllers
class ApplicationController < ActionController::Base ; end

class SnippController < ApplicationController

  ITEMTYPES.each {|e| define_method(e, lambda {}) }

end

#module Admin
#  class SnippController < ApplicationController
#
#    10.times do |e|
#      define_method ACTION_NAME.call(e) do
#        render text: ACTION_NAME.call(e), layout: "application"
#      end
#    end
#
#  end
#end

# helpers
Object.const_set(:ApplicationHelper, Module.new)
