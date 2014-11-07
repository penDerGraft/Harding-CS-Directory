class RemoveGradDate < ActiveRecord::Migration
  def change
  	remove_column :users, :grad_date
  end
end
