# Helpers to define and render the main menu of the cms part.
require 'cms/components/menu_link'

module MainMenuHelper
  include Cms::Components

  def menu_links(site)
    ([
      MenuLink.new(
        name: t('comfy.admin.cms.base.pages'),
        path: comfy_admin_cms_site_pages_path(site),
        custom_class: 'nav-primary__text--logo'
      ),
      MenuLink.new(name: t('comfy.admin.cms.base.files'), path: comfy_admin_cms_site_files_path(site))
    ] << admin_links(site)).flatten
  end

  def admin_links(site)
    return [] unless current_user.admin?
    [
      MenuLink.new(
        name:     t('comfy.admin.cms.base.admin'),
        path:     '#',
        sublinks: [
          MenuLink.new(name: t('comfy.admin.cms.base.users'),    path: users_path),
          MenuLink.new(name: t('comfy.admin.cms.base.tags'),     path: tags_path),
          MenuLink.new(name: t('comfy.admin.cms.base.categories'), path: categories_path),
          MenuLink.new(name: t('comfy.admin.cms.base.redirects'), path: redirects_path)
        ]
      )
    ]
  end
end
