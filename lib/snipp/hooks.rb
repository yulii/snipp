module Snipp
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Snipp::ActionViewExtension
      end
    end
  end
end
