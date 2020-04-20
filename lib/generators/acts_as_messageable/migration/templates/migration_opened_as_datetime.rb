class AddOpenedAtToMessages < ActiveRecord::Migration[4.2]
  def self.up
    add_column :<%= table_name %>, :opened_at, :datetime
    ActsAsMessageable::Message.where(opened: true).update_all(opened_at: DateTime.now)
  end

  def self.down
    ActsAsMessageable::Message.where('opened_at is not null').update_all(opened: true)
    remove_column :<%= table_name %>, :opened_at
  end
end
