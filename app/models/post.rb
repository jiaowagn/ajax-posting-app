class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, :optional => true 
  has_many :likes, dependent: :destroy
  has_many :liked_users, :through => :likes, :source => :user

  validates_presence_of :content

  def find_like(user)
    self.likes.where(:user_id => user.id).first
  end
end
