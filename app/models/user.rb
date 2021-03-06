class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :drivers
  has_one :report

  def full_name
    "#{first_name} #{last_name}"
  end

  validates :account_type, :inclusion  => {
    :in => [ 'admin', 'updater', 'dispatcher' ],
    :message => 'User type must be one of admin, updater, or dispatcher'
  }

end
