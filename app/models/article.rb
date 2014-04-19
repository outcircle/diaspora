class Article < ActiveRecord::Base
  attr_accessible :author_id, :content, :title
  belongs_to :user
end
