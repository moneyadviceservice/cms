# Helpers to define and render the main menu of the cms part.
module MainMenuHelper
  private

  MAIN_MENU_OPTION_CSS_CLASS        = 'nav-primary__text'
  MAIN_MENU_OPTION_CSS_ACTIVE_CLASS = 'is-active'

  # Options of the admin main menu and their properties.
  # Add new ones here for them to appear in the views.
  def main_menu_options(site:)
    @main_menu_options       ||= {}
    @main_menu_options[site] ||= {pages:    {display_name: t('comfy.admin.cms.base.pages'),
                                             path:         comfy_admin_cms_site_pages_path(site)},
                                  files:    {display_name: t('comfy.admin.cms.base.files'),
                                             path:         comfy_admin_cms_site_files_path(site)},
                                  snippets: {display_name: t('comfy.admin.cms.base.snippets'),
                                             path:         comfy_admin_cms_site_snippets_path(site)},
                                  layouts:  {display_name: t('comfy.admin.cms.base.layouts'),
                                             path: comfy_admin_cms_site_layouts_path(site)},
                                  tags:     {display_name: t('cms.admin.cms.base.tags'),
                                             path:         tags_path}}
  end

  # Renders the links to every option of the main menu of a given site.
  def render_main_menu(site:)
    main_menu_options(site: site).map do |_, properties|
      render_main_menu_option(option: properties)
    end.join
  end

  # Renders the link to a given option of a site main menu.
  # option: hash of properties of the option (:display_name, :path)
  def render_main_menu_option(option:)
    css_classes_when_active    = [MAIN_MENU_OPTION_CSS_CLASS, MAIN_MENU_OPTION_CSS_ACTIVE_CLASS].join(' ')
    css_classes_when_no_active = MAIN_MENU_OPTION_CSS_CLASS
    active_link_to(option[:display_name],
                   option[:path],
                   class_active: css_classes_when_active,
                   class_inactive: css_classes_when_no_active)
  end
end
