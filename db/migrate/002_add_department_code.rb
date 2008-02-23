class AddDepartmentCode < ActiveRecord::Migration
  def self.up
    add_column :departments, :code, :string
  end

  def self.down
    remove_column :departments, :column
  end
end
