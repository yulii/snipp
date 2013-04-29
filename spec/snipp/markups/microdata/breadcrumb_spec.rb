# coding: UTF-8
require 'spec_helper'

class Snipp::Markup::Microdata::Spec

  BREADCRUMBS = [
    { id: "#case-A-1", path: [:index, :foods, :fruits], separator: '>' },
    { id: "#case-A-2", path: [:index, :foods, :fruits], separator: '/' },
    { id: "#case-B-1", path: [:index, :foods, :fruits, :fruits_color, :food], separator: '/', params: [:color, :name] },
#    { id: "#case-B-2", path: [:index, :foods, :fruits, { path: app.fruits_color_path('Red'), label: 'Red' }, { path: app.food_path(color: 'Red', name: 'Apple'), label: 'Apple' }], separator: '/' },
#    { id: "#case-B-3", path: [:index, :foods, :fruits, { path: app.fruits_color_path, label: :fruits_color }, { path: app.food_path, label: :food }], separator: '/', params: [:color, :name] },
  ]

end

describe Snipp::Markup::Microdata do

  before do
    Snipp::Hooks.init
    visit "/foods/fruits/Red/Apple"
  end

  let(:itemtype) { "http://data-vocabulary.org/Breadcrumb" }

  describe "breadcrumbs" do

    Snipp::Markup::Microdata::Spec::BREADCRUMBS.each do |e|
      context e[:id] do
        it "should have a `nav[itemscope]` tag" do
          within(e[:id]) { expect(page).to have_selector("nav[itemtype=\"#{itemtype}\"][itemscope]", count: 1) }
        end
        it "should have correct number of `div[itemscope]` tags" do
          within(e[:id]) { expect(page).to have_selector("div[itemtype=\"#{itemtype}\"][itemscope]", count: (e[:path].size - 1)) }
        end
        it "should have correct number of `itemprop` attribute that equals `child`" do
          within(e[:id]) { expect(page).to have_selector('[itemprop="child"][itemscope]', count: (e[:path].size - 1)) }
        end
        it "should have correct number of `a[itemprop\"url\"]` tags" do
          within(e[:id]) { expect(page).to have_selector('a[itemprop="url"]', count: e[:path].size) }
        end
        it "should have correct number of `span[itemprop\"title\"]` tags" do
          within(e[:id]) { expect(page).to have_selector('span[itemprop="title"]', count: e[:path].size) }
        end
        it "should have correct number of separators" do
          within(e[:id]) { expect(page).to have_content(e[:separator], count: (e[:path].size - 1)) }
        end
      end
    end

    describe "a variety of ways to define breadcrumbs" do
      let(:html) { page.find("#case-B-1 nav").native.to_s }

      it "should be equivalent" do
        expect(page.find("#case-B-2 nav").native.to_s).to eq html
      end
      it "should be equivalent" do
        expect(page.find("#case-B-3 nav").native.to_s).to eq html
      end
    end
  end

end
