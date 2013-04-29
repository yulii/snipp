module Snipp
  module Markup
    module Microdata

      def breadcrumb paths, options = {}
        sepalator = "&nbsp;#{options.delete(:sepalator)||options.delete(:s)||'&gt;'}&nbsp;"
        sepalator << "<div#{item_options prop: :child, scope: true, type: :breadcrumb}>"
  
        # options for i18n
        i18n_options = { scope: [:views, :breadcrumb] }
        (options[:args]||[]).each do |e|
          i18n_options[e] = params[e]
        end
  
        bc = []
        paths.each do |e|
          if e.is_a?(Hash)
            body = item_tag :span, I18n.t(e[:label], i18n_options.merge(default: e[:label])), prop: :title
            bc.push link_to body, e[:path], itemprop: :url
          else
            body = item_tag :span, I18n.t(e, i18n_options), prop: :title
            bc.push link_to body, send("#{e}_path"), itemprop: :url
          end 
        end
        output = "<nav class=\"breadcrumb\"#{item_options scope: true, type: :breadcrumb}>"
        output << bc.join(sepalator)
  
        (paths.size - 1).times do
          output << '</div>'
        end
        output << '</nav>'
  
        return output.html_safe
      end 

      def geo latitude, longitude, options = {}
        item_tag :span, prop: :geo, scope: true, type: :geo, class: "geo" do
          "#{item_tag :span, latitude, prop: :latitude}#{item_tag :span, longitude, prop: :longitude}".html_safe
        end
      end

      def item_tag name, content_or_options_with_block = nil, options = nil, escape = true, &block
        if block_given?
          options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
          content = capture(&block)
        else
          content = content_or_options_with_block
        end
        item_options = item_options options, escape if options
        tag_options  = tag_options  options, escape if options
        content = if block_given? then capture(&block) else content_or_options_with_block end
         "<#{name}#{tag_options}#{item_options}>#{escape ? ERB::Util.h(content) : content}</#{name}>".html_safe
      end

      def item_options options, escape = true
        attrs = ''
        attrs << " itemprop=\"#{escape ? ERB::Util.h(options.delete :prop) : options.delete(:prop)}\"" if options.key? :prop
        attrs << " itemscope" if options.delete :scope
        attrs << " itemtype=\"http://data-vocabulary.org/#{options.delete(:type).to_s.camelize}\"" if options.key? :type
        attrs.html_safe
      end

    end
  end
end
