module Snipp
  module Markup
    module Html

      def set_html_meta args, options = {}
        merger = lambda {|key, old, new| Hash === old && Hash === new ? old.merge(new, &merger) : new }
        html_meta.merge!(args, &merger)
        meta_options.merge!(options)
      end

      def set_html_meta! args
        @html_meta = args
      end

      def html_meta_tags
        result = ''

        meta_link = html_meta.delete(:link)||{}

        # Title
        title = html_meta.delete(:title)
        title = select_content(:title) if title.empty?
        result << content_tag(:title, title) unless title.blank?

        html_meta.each do |name, value| 
          if value.is_a?(Hash)
            result << build_property_contents(value, name, name)
          else
            result << build_contents(name, value)
          end
        end

        meta_link.each do |rel, href|
          result << tag(:link, rel: rel, href: href) unless href.blank?
        end
    
        result.blank? ? nil : result.html_safe
      end

      private
      def html_meta
        @html_meta ||= Snipp.config.html_meta.dup
      end

      def meta_options
        @meta_options ||= { default: '' }
      end

      def select_content key, options = {}
#puts key
        options[:scope]   ||= "views.#{params[:controller].gsub(%r{/}, '.')}.#{params[:action]}.meta"
        options[:default] ||= 'default.meta'
        content = I18n.t("#{options[:scope]}.#{key}"   ,meta_options)
        content = I18n.t("#{options[:default]}.#{key}" ,default: '') if content.empty?
        content
      end

      # <meta name="xxx" content="yyy" />
      def build_contents name, content
        result = ''
        Array(content).each do |content|
#puts "#{name} => #{content}"
          content = select_content(name) if content.empty?
          result << tag(:meta, name: name, content: content) unless content.empty?
        end
        result
      end

      # <meta property="xxx:yyy" content="zzz" />
      def build_property_contents values, property, key
        result = ''
        if values.is_a?(Hash)
          values.each do |k, v|
            result << build_property_contents(v, "#{property}:#{k}", "#{key}.#{k}")
          end
        else
          Array(values).each do |content|
            if content.is_a?(Hash)
              result << build_contents(content, property, key)
            else
#puts "#{key} => #{content}"
              content = select_content(key) if content.empty?
              result << tag(:meta, property: "#{property}", content: content) unless content.empty?
            end
          end
        end
        result
      end

    end
  end
end
