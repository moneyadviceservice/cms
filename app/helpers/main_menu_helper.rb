# Helpers to define and render the main menu of the cms part.
require 'cms/components/menu_link'

module MainMenuHelper
  include Cms::Components

  def menu_links
    ([
      MenuLink.new(name: t('comfy.admin.cms.base.pages'), path: comfy_admin_cms_site_pages_path(@site)),
      MenuLink.new(name: t('comfy.admin.cms.base.files'), path: comfy_admin_cms_site_files_path(@site))
    ] << admin_links).flatten
  end

  def admin_links
    return [] unless current_user.admin?
    [
      MenuLink.new(
        name:     t('comfy.admin.cms.base.admin'),
        path:     '#',
        sublinks: [
          MenuLink.new(name: t('comfy.admin.cms.base.admin'),    path: users_path),
          MenuLink.new(name: t('comfy.admin.cms.base.layouts'),  path: comfy_admin_cms_site_layouts_path(@site)),
          MenuLink.new(name: t('comfy.admin.cms.base.tags'),     path: tags_path),
          MenuLink.new(name: t('comfy.admin.cms.base.snippets'), path: comfy_admin_cms_site_snippets_path(@site))
        ]
      )
    ]
  end
end
