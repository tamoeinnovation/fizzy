class AddIndexToSearchQueries < ActiveRecord::Migration[8.1]
  def change
    add_index :search_queries, %w[ user_id updated_at ], unique: true
  end
end
