# typed: false
# frozen_string_literal: true

class UuidUser < ActiveRecord::Base
  acts_as_messageable class_name: 'CustomMessageUUID', table_name: 'custom_messages_uuid'
  self.table_name = :uuid_users
end
