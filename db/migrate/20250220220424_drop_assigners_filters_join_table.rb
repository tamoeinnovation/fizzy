class DropAssignersFiltersJoinTable < ActiveRecord::Migration[8.1]
  class DropAssignersFiltersJoinTable < ActiveRecord::Migration[7.1]
    def change
      drop_table :assigners_filters if table_exists?(:assigners_filters)
    end
  end
end
