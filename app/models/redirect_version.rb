class RedirectVersion < PaperTrail::Version
  self.table_name = :redirect_versions

  def user
    Comfy::Cms::User.find_by(id: whodunnit)
  end

  def updated_by
    begin
      user.email_local_part
    rescue ActiveRecord::RecordNotFound => e
      "deleted user"
    end
  end
end
