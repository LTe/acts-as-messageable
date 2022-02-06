# typed: ignore
# frozen_string_literal: true

class CustomMessageUUID < ActsAsMessageable::Message
  self.table_name = :custom_messages_uuid
end
