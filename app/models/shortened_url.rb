class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, :uniqueness => true
  validates :short_url, :uniqueness => true
  validates :submitter_id, :presence => true
  validates :short_url, :presence => true
  
  
  def self.random_code
    while true
      code = SecureRandom::urlsafe_base64(16)
      return code unless ShortenedUrl.exists?(['short_url = ?', code])
    end
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(
      submitter_id: user.id,
      long_url: long_url,
      short_url: self.random_code
    )
  end
  
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )
  
  has_many(
  :visits,
  class_name: 'Visit',
  foreign_key: :shortened_url_id,
  primary_key: :id
  )
  
  has_many(
  :visiting_users,
  -> { distinct },
  through: :visits,
  source: :visitor
  )
  
  def num_clicks
    visits.count 
  end
  
  def num_uniques
    visiting_users.count 
  end
  
  def num_recent_uniques
    visits.select(:user_id).where('created_at > ?', Time.now - 600).distinct.count
  end
end 