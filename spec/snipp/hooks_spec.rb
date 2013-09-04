# coding: UTF-8
require 'spec_helper'

describe Snipp::Hooks do

  let(:execute) { lambda { Snipp::Hooks.init } }

  context "when calls `Snipp::Hooks.init`" do
    it { expect(execute).not_to raise_error }
  end

  context "when `Snipp.config.markup` is invalid" do
    before do
      Snipp.configure do |config|
        config.markup = :undefined
      end
    end

    it { expect(execute).to raise_error(NotImplementedError) }
  end

  after do
    Snipp.configure do |config|
      config.markup = :microdata
    end
  end

end
