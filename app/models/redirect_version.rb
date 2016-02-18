class RedirectVersion < PaperTrail::Version
  self.table_name = :redirect_versions

  def user
    Comfy::Cms::User.find_by(id: whodunnit)
  end
end
