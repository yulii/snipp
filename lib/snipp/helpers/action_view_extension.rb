module Snipp
  module ActionViewExtension

    # = breadcrumb [ :root, :seach, :item } ], s: "/"
    # @params paths
    # @params options
    def breadcrumb paths, options = {}
      sepalator = "&nbsp;#{options.delete(:sepalator)||options.delete(:s)||'&gt;'}&nbsp;"
      sepalator << '<div itemprop="child" itemscope itemtype="http://data-vocabulary.org/Breadcrumb">'

      i18n_options = options.merge({ scope: [:views, :breadcrumb] })

      bc = []
      paths.each do |e|
        body = content_tag :span, I18n.t(e, i18n_options), itemprop: :title
        bc.push link_to body, send("#{e}_path", options), itemprop: :url
      end
      code = '<nav itemscope itemtype="http://data-vocabulary.org/Breadcrumb">'
      code << bc.join(sepalator)

      (paths.size - 1).times do
        code << '</div>'
      end
      code << '</nav>'

      return code.html_safe
    end 

  end
end
