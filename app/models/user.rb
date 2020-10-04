class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  # フォローする側のリレーションシップ
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  # N：Nのリレーションシップにはthroughを使う。user.following = user.followed.idとなるようにsourceを設定
  has_many :following, through: :active_relationships, source: :followed

  # フォロワーのリレーションシップ
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id
  # N：Nのリレーションシップにはthroughを使う。user.followers = user.follower.idとなるようにsourceを設定
  has_many :followers, through: :passive_relationships, source: :follower
 
  #すでにフォロー済みであればture返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  attachment :profile_image, destroy: false

  validates :name,length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}
end
