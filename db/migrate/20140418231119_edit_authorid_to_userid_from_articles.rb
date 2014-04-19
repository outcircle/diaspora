class EditAuthoridToUseridFromArticles < ActiveRecord::Migration
  def up
  	rename_column :articles, :author_id, :person_id
  end

  def down
  	rename_column :articles, :person_id, :author_id
  end
end
