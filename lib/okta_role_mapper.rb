module OktaRoleMapper
  OKTA_MAPPINGS = {
    ENV["OKTA_USER_GROUP_NAME"]   => 0,
    ENV["OKTA_ADMIN_GROUP_NAME"]  => 1,
    ENV["OKTA_EDITOR_GROUP_NAME"] => 2,
  }

  def convert_okta_group_to_role(group_name)
    # Defaults to "User" role if no matching role is found
    OKTA_MAPPINGS[group_name] || 0
  end
end
