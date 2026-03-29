class RenameEmailToLoginInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :email, :login
  end
end
