module ApplicationHelper

  # Options of the admin main menu and their properties.
  # Add new ones here for them to appear in the views.
  def admin_main_menu_options_of_site(site)
    @main_menu_options       ||= {}
    @main_menu_options[site] ||= {:pages    => {:display_name => t('comfy.admin.cms.base.pages'),    :path => comfy_admin_cms_site_pages_path(site)},
                                  :files    => {:display_name => t('comfy.admin.cms.base.files'),    :path => comfy_admin_cms_site_files_path(site)},
                                  :snippets => {:display_name => t('comfy.admin.cms.base.snippets'), :path => comfy_admin_cms_site_snippets_path(site)},
                                  :layouts  => {:display_name => t('comfy.admin.cms.base.layouts'),  :path => comfy_admin_cms_site_layouts_path(site)}}
  end

end
