# coding: UTF-8
require 'spec_helper'

describe Snipp do

  before do
    Snipp::Hooks.init
    visit "/foods/fruits/Red/Apple"
  end

  it "should be no error" do
    expect(page).to have_content("Breadcumbs - Rich Snippets Sample")
  end
end
