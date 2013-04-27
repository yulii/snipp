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
SNIPP_TYPES = [:breadcumb]
app.routes.draw do
  get "/" =>"snipp#index" ,as: :root

  SNIPP_TYPES.each do |e|
    get "/e" => "index##{e}" ,as: e
  end

  # for Breadcumb
  get "/food"                 => "snipp#index", as: :food
  get "/food/fruit"           => "snipp#index", as: :food_fruit
  get "/food/fruit/red"       => "snipp#index", as: :food_fruit_red
  get "/food/fruit/red/apple" => "snipp#index", as: :food_fruit_red_apple
end

# controllers
class ApplicationController < ActionController::Base ; end

class SnippController < ApplicationController

  def index ; end

end


# helpers
Object.const_set(:ApplicationHelper, Module.new)
