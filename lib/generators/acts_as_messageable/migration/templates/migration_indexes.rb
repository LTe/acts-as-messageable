# typed: ignore
class AddIndexesToMessages < ActiveRecord::Migration[4.2]
  def self.up
    add_index :<%= table_name %>, [:sent_messageable_id, :sent_messageable_type], :name => "acts_as_messageable_sent"
    add_index :<%= table_name %>, [:received_messageable_id, :received_messageable_type], :name => "acts_as_messageable_received"
  end

  def self.down
    remove_index :<%= table_name %>, :name => "acts_as_messageable_sent"
    remove_index :<%= table_name %>, :name => "acts_as_messageable_received"
  end
end
