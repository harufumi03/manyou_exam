class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM tasks;'
    add_column :tasks, :user_id, :integer
  end
end
