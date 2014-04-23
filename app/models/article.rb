class Article < ActiveRecord::Base
  attr_accessible :author_id, :content, :title
  belongs_to :user
  belongs_to :author, :class_name => 'Person'

  
  include Diaspora::Likeable

  def subscribers(user)
    
  end
end
