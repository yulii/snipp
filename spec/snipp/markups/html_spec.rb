# coding: UTF-8
require 'spec_helper'

class Snipp::Markup::Html::Spec

  DEFAULT_SCOPE = [:default, :meta]
  PAGE_SCOPE    = [:views, :snipp, :html, :meta]

  META = [
    { id: "TDK", title: I18n.t(:title, scope: PAGE_SCOPE, value: "Embedding Values"), description: I18n.t(:description, scope: DEFAULT_SCOPE), keywords: I18n.t(:keywords, scope: DEFAULT_SCOPE) }
  ]

end

describe Snipp::Markup::Html do

  before do
    Snipp::Hooks.init
    visit "/html"
  end

  describe "HTML Meta Tags" do

    Snipp::Markup::Html::Spec::META.each do |e|
      id = e.delete(:id)
      context id do
        e.each do |key, value|
          it "should have a `#{key}` tag" do
            expect(page).to have_selector("meta[name=\"#{key}\"][content=\"#{value}\"]", count: 1)
          end
        end
      end
    end

  end

end
