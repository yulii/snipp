# coding: UTF-8
require 'spec_helper'

describe Snipp::Markup::Html do

  let(:view) do
    clazz = Class.new do
      include ActionView::Helpers
      include Snipp::Markup::Html
    end
    view = clazz.new
    view.stub(:params).and_return(params)
    view
  end

  let(:params) { { controller: "snipp", action: "html" } }

  describe "#set_html_meta" do
    let(:args) do
      {
        title: "Spec Title",
        description: "Spec Description",
        keywords: "Spec Keywords",
        og: {
          site_name: "Spec OG Site Name",
          title: "Spec OG Title",
          description: "Spec OG Description",
          type: "article",
          image: "https://github.com/yulii/snipp"
        },
        link: {
          canonical: "https://github.com/yulii/snipp"
        }
      }
    end

    let(:object) do
      view.set_html_meta(args.dup)
      view.send(:html_meta)
    end

    it do
      expect(object).to include(args)
    end

    context "when do nothing" do
      let(:params) { { controller: "nothing", action: "undefined" } }
      let(:args) do
        Snipp.config.html_meta.select {|k, v| not v.nil? and not v.empty? }
      end

      it do
        expect(object).to include(args)
      end
    end
  end

  describe "#html_meta_tags" do
    let(:args) do
      {
        title: "Spec Title",
        description: "Spec Description",
        keywords: "Spec Keywords",
        og: {
          site_name: "Spec OG Site Name",
          title: "Spec OG Title",
          description: "Spec OG Description",
          type: "article",
          url: "https://github.com/yulii/snipp",
          image: "https://github.com/yulii/snipp"
        },
        link: {
          canonical: "https://github.com/yulii/snipp"
        }
      }
    end

    let(:object) do
      view.set_html_meta(args.dup)
      view.send(:html_meta_tags)
    end

    it { expect(object).to include(view.content_tag(:title, args[:title])) }
    [:description, :keywords].each do |name|
      it { expect(object).to include(view.tag(:meta, name: name, content: args[name])) }
    end
    [:site_name, :title, :description, :type, :url, :image].each do |property|
      it { expect(object).to include(view.tag(:meta, property: "og:#{property}", content: args[:og][property])) }
    end
    [:canonical].each do |rel|
      it { expect(object).to include(view.tag(:link, rel: rel, href: args[:link][rel])) }
    end

  end

  describe "#select_content" do
    let(:options) do
      { value: 'Value', default: '' }
    end

    let(:object) do
      view.stub(:meta_options).and_return(options)
      view
    end

    context "when there is I18n dictionary of controller/action" do
      [:title, :description].each do |key|
        it { expect(object.send(:select_content, key)).to eq(I18n.t("views.snipp.html.meta.#{key}", options)) }
      end
    end

    context "when there is NOT I18n dictionary of controller/action" do
      let(:params) { { controller: "nothing", action: "undefined" } }
   
      [:title, :description, :keywords].each do |key|
        it { expect(object.send(:select_content, key)).to eq(I18n.t("default.meta.#{key}")) }
      end 
      [:site_name, :title, :description, :type].each do |property|
        it { expect(object.send(:select_content, "og.#{property}")).to eq(I18n.t("default.meta.og.#{property}")) }
      end
    end

    context "when there is no I18n dictionaries" do
      [:nothing, :undefined].each do |key|
        it { expect(view.send(:select_content, key)).to be_empty }
      end
    end
  end

  describe "#build_contents" do
    context "when content is Scalar" do
      it do
        expect(
          view.send(:build_contents, :name, 'content')
        ).to eq(
          view.tag(:meta, name: :name, content: 'content')
        )
      end
    end
    context "when content is Array" do
      it do
        expect(
          view.send(:build_contents, 'robots', ['index', 'follow'])
        ).to eq(
          view.tag(:meta, name: 'robots', content: 'index') +
          view.tag(:meta, name: 'robots', content: 'follow')
        )
      end
    end
    context "when content is empty string" do
      it { expect(view.send(:build_contents, :name, '')).to be_empty }
    end
  end

  context "when HTML document has rendered" do
    before(:all) do
      Snipp::Hooks.init
      visit "/html"
    end

    let(:scope)   { 'views.snipp.html.meta' }
    let(:default) { 'default.meta' }
    let(:url)     { 'http://127.0.0.1/canonical' }

    # HTML Meta
    it { expect(page).to have_selector("title", count: 1, text: I18n.t("#{scope}.title" ,value: "Embedding Values")) }
    it { expect(page).to have_selector("meta[name=\"description\"][content=\"#{I18n.t("#{scope}.description")}\"]", count: 1) }
    it { expect(page).to have_selector("meta[name=\"keywords\"][content=\"#{I18n.t("#{default}.keywords")}\"]", count: 1) }

    # Open Graph
    it { expect(page).to have_selector("meta[property=\"og:site_name\"][content=\"#{I18n.t("#{default}.og.site_name")}\"]", count: 1) }
    it { expect(page).to have_selector("meta[property=\"og:type\"][content=\"#{I18n.t("#{default}.og.type")}\"]", count: 1) }
    it { expect(page).to have_selector("meta[property=\"og:title\"][content=\"#{I18n.t("#{scope}.og.title" ,text: "Insert")}\"]", count: 1) }
    it { expect(page).to have_selector("meta[property=\"og:description\"][content=\"#{I18n.t("#{default}.og.description")}\"]", count: 1) }

    # Link Tags
    it { expect(page).to have_selector("link[rel=\"canonical\"][href=\"#{url}\"]", count: 1) }
  end

end
