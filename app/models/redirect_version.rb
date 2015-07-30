class RedirectVersion < PaperTrail::Version
  self.table_name = :redirect_versions

  def user
    Comfy::Cms::User.find(whodunnit)
  end
end
