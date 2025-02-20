class CreateCreatorsFiltersJoinTable < ActiveRecord::Migration[8.1]
  def change
    create_table :creators_filters, id: false do |t|
      t.integer :filter_id, null: false
      t.integer :creator_id, null: false
    end

    add_index :creators_filters, :filter_id
    add_index :creators_filters, :creator_id
  end
end
