class AddJobInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_title, :string
    add_column :users, :company_or_organization, :string
  end
end
