class RemoveStatusFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_index :tasks, :status
    remove_column :tasks, :status, :string
  end
end
