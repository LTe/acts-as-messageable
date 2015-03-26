class AddOpenedAtToMessages < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :opened_at, :datetime
    <%= table_name.classify %>.where(opened:true).update_all(opened_at: DateTime.now)
    remove_column :<%= table_name %>, :opened
  end

  def self.down
    add_column :<%= table_name %>, :opened, :boolean, default: false
    <%= table_name.classify %>.where.not(opened_at:nil).update_all(opened: true)
    remove_column :<%= table_name %>, :opened_at
  end
end
