class Comfy::Cms::User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:saml]

  validates :role, presence: true

  enum role: { user: 0, admin: 1, editor: 2 }

  def email_local_part
    email.split('@').first
  end
end
