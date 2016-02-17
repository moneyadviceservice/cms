class Comfy::Cms::User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  ADMIN = 1

  def email_local_part
    email.split('@').first
  end

  def admin?; self.role == ADMIN; end
end
