class Article < ActiveRecord::Base
  attr_accessible :author_id, :content, :title
  belongs_to :user
  belongs_to :author, :class_name => 'Person'

  
  include Diaspora::Likeable
  include Diaspora::Commentable

  def subscribers(user)
    
  end
end
