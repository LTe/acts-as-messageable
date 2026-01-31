# typed: ignore
class AddIndexesToMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :<%= table_name %>, [:sent_messageable_id, :sent_messageable_type], name: "acts_as_messageable_sent"
    add_index :<%= table_name %>, [:received_messageable_id, :received_messageable_type], name: "acts_as_messageable_received"
  end
end
