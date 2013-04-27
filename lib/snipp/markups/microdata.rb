module Snipp
  module Markup
    module Microdata

      def breadcrumb paths, options = {}
        sepalator = "&nbsp;#{options.delete(:sepalator)||options.delete(:s)||'&gt;'}&nbsp;"
        sepalator << '<div itemprop="child" itemscope itemtype="http://data-vocabulary.org/Breadcrumb">'
  
        # options for i18n
        i18n_options = { scope: [:views, :breadcrumb] }
        (options[:params]||[]).each do |e|
          i18n_options[e] = params[e]
        end
  
        bc = []
        paths.each do |e|
          if e.is_a?(Hash)
            body = content_tag :span, I18n.t(e[:label], i18n_options.merge(default: e[:label])), itemprop: :title
            bc.push link_to body, e[:path], itemprop: :url
          else
            body = content_tag :span, I18n.t(e, i18n_options), itemprop: :title
            bc.push link_to body, send("#{e}_path"), itemprop: :url
          end 
        end
        output = '<nav class="breadcrumb" itemscope itemtype="http://data-vocabulary.org/Breadcrumb">'
        output << bc.join(sepalator)
  
        (paths.size - 1).times do
          output << '</div>'
        end
        output << '</nav>'
  
        return output.html_safe
      end 

    end
  end
end
