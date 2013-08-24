module Snipp
  module Markup
    module Html

      def set_html_meta args, options = {}
        i18n_options = {
          scope: [:views, params[:controller], params[:action], :meta],
          default_scope: [:default, :meta]
        }.merge(options)

        link = args.delete(:link)
        html_meta.merge!(link: link) if link

        Snipp.config.html_meta_tags.merge(args).each do |name, content|
          value = html_meta_contents(name, content, i18n_options)
          html_meta[name] = value unless value.blank?
        end
      end

      def html_meta_tags
        result = ''
        set_html_meta({}) if html_meta.empty?
        meta_link = html_meta.delete(:link)||{}

        # TDK 
        title = html_meta.delete(:title)
        unless title.blank?
          result << content_tag(:title, title)
          result << tag(:meta, name: :title, content: title)
        end
    
        html_meta.each do |name, content|
          if content.is_a?(Hash)
            result << build_meta_property_tags(name, content)
          else
            Array(content).each do |c|
              result << tag(:meta, name: name, content: c) unless c.blank?
            end
          end
        end

        meta_link.each do |rel, href|
          result << tag(:link, :rel => rel, :href => href) unless href.blank?
        end
    
        result.blank? ? nil : result.html_safe
      end

      private    
      def html_meta_contents property, content, options = {}
        result = {}
        if content.is_a?(Hash)
          content.each do |key, value|
            options = options.dup
            options[:scope]         << property
            options[:default_scope] << property
            result[key] = html_meta_contents(key, value, options)
          end
        else
          result = content
          result = I18n.t(property, options.merge(default: '')) if result.blank?
          result = I18n.t(property, scope: options[:default_scope], default: '') if result.blank?
        end
        result
      end

      def build_meta_property_tags(property, content)
        result = ''
        if content.is_a?(Hash)
          content.each do |key, value|
            result << build_meta_property_tags("#{property}:#{key}", value)
          end
        else
          Array(content).each do |c|
            if c.is_a?(Hash)
              result << build_meta_property_tags(property, c)
            else
              result << tag(:meta, :property => "#{property}", :content => c) unless c.blank?
            end
          end
        end
        result
      end

      def html_meta
        @html_meta ||= {}
      end

    end
  end
end
