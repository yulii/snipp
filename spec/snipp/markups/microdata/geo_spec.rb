# coding: UTF-8
require 'spec_helper'

class Snipp::Markup::Microdata::Spec

  GEO = [
    { id: "#case-A-1", latitude: 38.5323, longitude: 77.0040 },
  ]

end

describe Snipp::Markup::Microdata do

  before do
    Snipp::Hooks.init
    visit "/geo"
#    puts page.html
  end

  let(:itemtype) { "http://data-vocabulary.org/Geo" }

  shared_examples_for 'defined the latitude and longitude' do |e|
    puts e
#    within(e[:id]) do
      it { expect(page).to have_selector('[itemprop="latitude"]', text: e[:latitude], count: 1) }
      it { expect(page).to have_selector('[itemprop="longitude"]', text: e[:longitude], count: 1) }
#    end
  end

  describe "geo" do

    Snipp::Markup::Microdata::Spec::GEO.each do |e|
      context e[:id] do
        it "should have a `span[itemscope]` tag" do
          within(e[:id]) { expect(page).to have_selector("span[itemtype=\"#{itemtype}\"][itemscope]", count: 1) }
        end
        [:latitude, :longitude].each do |arg|
          it "should have a `itemprop` attribute that equals `#{arg}`" do
            within(e[:id]) { expect(page).to have_selector("[itemprop=\"#{arg}\"]", count: 1) }
          end
        end
        it_should_behave_like 'defined the latitude and longitude', e
      end
    end

  end

end
