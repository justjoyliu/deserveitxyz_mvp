# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  last_name       :string
#  email           :string
#  sms             :string
#  permalink       :string
#  activation_flag :boolean          default(FALSE)
#  activation_code :string
#  password_digest :string
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string
#

class User < ActiveRecord::Base

	before_save { |user| user.email = email.downcase }
	before_create :make_permalink
	before_create :make_activation_code

  # validations
    validates :name,  presence: true #, length: { :within => 3..30 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    # validates :password, length: { minimum: 6 }
    # validates :password_confirmation, presence: true

  has_secure_password validations: false

  # has_many :goals, dependent: :destroy
  has_many :goals
  has_many :checkins

  def active_goal
    return self.goals.where('goal_status= ?', 1).first
  end

  private

    def make_permalink
    	self.permalink = loop do
      		# random_token = SecureRandom.urlsafe_base64(nil, false)
        	random_token = SecureRandom.hex(8)
        	break random_token unless User.where(permalink: random_token).exists?
    	end
    end

   	def make_activation_code
   		self.activation_code = SecureRandom.hex(5)
   	end
end
