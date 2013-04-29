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
ITEMTYPES = [:index, :breadcrumb, :geo]
app.routes.draw do

  ITEMTYPES.each do |e|
    get "/#{e}" => "snipp##{e}", as: e
  end

  # for Breadcumb
  get "/foods"                     => "snipp#breadcrumb", as: :foods
  get "/foods/fruits"              => "snipp#breadcrumb", as: :fruits
  get "/foods/fruits/:color"       => "snipp#breadcrumb", as: :fruits_color
  get "/foods/fruits/:color/:name" => "snipp#breadcrumb", as: :food
end

# controllers
class ApplicationController < ActionController::Base ; end

class SnippController < ApplicationController

  ITEMTYPES.each do |e|
    define_method e do
    end
  end

end


# helpers
Object.const_set(:ApplicationHelper, Module.new)
