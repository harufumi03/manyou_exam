class ChangeColumnToNull < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :created_at, :datetime, precision: 6, null: true
    change_column :tasks, :updated_at, :datetime, precision: 6, null: true 
  end

  def down
    change_column :tasks, :created_at, :datetime, precision: 6, null: false
    change_column :tasks, :updated_at, :datetime, precision: 6, null: false 
  end
end
