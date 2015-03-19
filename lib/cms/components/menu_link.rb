module Cms
  module Components
    class MenuLink
      include ActiveModel::Model
      attr_accessor :name, :path, :sublinks, :custom_class

      def sublinks?
        sublinks.present?
      end

      def add_active_class(view)
        'is-active' if view.request.url.match(path)
      end

      def link_class
        ['nav-primary__text', custom_class].compact.join(' ')
      end
    end
  end
end
