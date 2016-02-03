class Comfy::Cms::User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  validates :role, presence: true

  enum role: { author: 0, admin: 1 }

  def email_local_part
    email.split('@').first
  end
end
