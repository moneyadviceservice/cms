class MigrateUsersToHaveRole < ActiveRecord::Migration
  def up
    Comfy::Cms::User.all.each do |user|
      user.update_attribute(:role, new_role_for(user))
    end
  end

  def down
    Comfy::Cms::User.all.each do |user|
      user.update_attribute(:admin, user.admin?)
    end
  end

  private

  def new_role_for(user)
    if user.read_attribute(:admin)
      Comfy::Cms::User.roles[:admin]
    else
      Comfy::Cms::User.roles[:author]
    end
  end
end
