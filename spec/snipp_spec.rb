# coding: UTF-8
require 'spec_helper'

describe Snipp do

  before do
    Snipp::Hooks.init
    visit "/"
    puts page.html
  end

  describe do
    it { expect(true).to be_true }
  end

end
