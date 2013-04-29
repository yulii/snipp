# coding: UTF-8
require 'spec_helper'

describe Snipp do

  before do
    Snipp::Hooks.init
  end

  ITEMTYPES.each do |e|
    describe "no errors" do
      before do
        case e
        when :breadcrumb
          visit "/foods/fruits/Red/Apple"
        else
          visit send("#{e}_path")
        end
      end
      it "should have no errors when visits /#{e}" do
        expect(page).to have_content("#{e.to_s.camelize} - Rich Snippets Sample")
      end
    end
  end
end
