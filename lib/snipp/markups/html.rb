module Snipp
  module Markup
    module Html

      def set_html_meta args, options = {}
        i18n_options = {
          scope: [:views, params[:controller], params[:action]],
          default_scope: [:default]
        }.merge(options)

        @html_meta = html_meta_content :meta, Snipp.config.html_meta_tags.merge(args), i18n_options
      end

      def html_meta property
        @html_meta ? @html_meta[:meta][property] : nil
      end

      def html_meta_tags
        result = ''
   
        # TDK 
        title = html_meta(:title)
        unless title.blank?
          result << content_tag(:title, title)
          result << tag(:meta, name: :title, content: title)
        end
    
        [:description, :keywords].each do |name|
          value = html_meta(name)
          content << tag(:meta, name: name, content: value) unless value.blank?
        end
    
        # Open Graph
        og = html_meta(:og)
        [:site_name, :type, :title, :description, :image].each do |property|
          content << tag(:meta, property: "og:#{property}", content: og[property]) unless og[property].blank?
        end
    
        [:author].each do |name|
          value = html_meta(name)
          content << tag(:meta, name: name, content: value) unless value.blank?
        end
    
        #canonical = meta_content :canonical, @meta_options
        #content << tag(:link, rel: :canonical, href: canonical) if canonical
    
        content.blank? ? nil : content.html_safe
      end

      private    
      def html_meta_content property, content, options = {}
        result = {}
        if content.is_a?(Hash)
          content.each do |key, value|
            options = options.dup
            options[:scope]         << property
            options[:default_scope] << property
            result[property] = html_meta_contents(key, value, options)
          end
        else
          result[property] = (content.blank? ? I18n.t(property, options.merge {
            default: I18n.t(property, scope: options[:default_scope], default: '')
          }) : content)
        end
        result
      end

    end
  end
end
