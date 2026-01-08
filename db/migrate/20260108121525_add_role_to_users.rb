class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        # update existing users
        User.reset_column_information
        User.where(role: nil).update_all(role: 0)
      end
      # dir.down nothing to do because the column will be automatically remove
    end
  end
end
