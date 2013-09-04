# coding: UTF-8
require 'spec_helper'

class Snipp::Markup::Html::Spec

  DEFAULT_SCOPE = [:default, :meta]
  PAGE_SCOPE    = [:views, :snipp, :html, :meta]

  META = {
    title:       I18n.t(:title       ,scope: PAGE_SCOPE, value: "Embedding Values"),
    description: I18n.t(:description ,scope: PAGE_SCOPE),
    keywords:    I18n.t(:keywords    ,scope: DEFAULT_SCOPE)
  }
  OG = {
    site_name:   I18n.t("og.site_name"   ,scope: DEFAULT_SCOPE),
    title:       I18n.t("og.title"       ,scope: PAGE_SCOPE    ,text: "Insert"),
    description: I18n.t("og.description" ,scope: DEFAULT_SCOPE),
    type:        "article"
  }
  LINK = {
    canonical: 'http://127.0.0.1/canonical'
  }
end

describe Snipp::Markup::Html do

  before do
    Snipp::Hooks.init
    visit "/html"
#puts page.html
  end

  context "HTML Meta Tags" do
    Snipp::Markup::Html::Spec::META.each do |key, value|
      it "should have a `#{key}` tag" do
        expect(page).to have_selector("meta[name=\"#{key}\"][content=\"#{value}\"]", count: 1)
      end
    end
    Snipp::Markup::Html::Spec::OG.each do |key, value|
      it "should have a `og:#{key}` tag" do
        expect(page).to have_selector("meta[property=\"og:#{key}\"][content=\"#{value}\"]", count: 1)
      end
    end
    Snipp::Markup::Html::Spec::LINK.each do |key, value|
      it "should have a `link[rel=\"#{key}\"]` tag" do
        expect(page).to have_selector("link[rel=\"#{key}\"][href=\"#{value}\"]", count: 1)
      end
    end
  end

end
