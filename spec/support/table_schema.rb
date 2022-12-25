# typed: strict
# frozen_string_literal: true

TABLE_SCHEMA = T.let(lambda do |t|
  t.string :topic
  t.text :body
  t.references :received_messageable, polymorphic: true, index: false
  t.references :sent_messageable, polymorphic: true, index: false
  t.boolean :opened, default: false
  t.boolean :recipient_delete, default: false
  t.boolean :sender_delete, default: false
  t.boolean :recipient_permanent_delete, default: false
  t.boolean :sender_permanent_delete, default: false
  t.datetime :opened_at, :datetime
  t.string :ancestry
  t.timestamps
end, T.untyped)

TABLE_SCHEMA_UUID = T.let(lambda do |t|
  t.string :topic
  t.text :body
  t.references :received_messageable, polymorphic: true, index: false, type: :uuid
  t.references :sent_messageable, polymorphic: true, index: false, type: :uuid
  t.boolean :opened, default: false
  t.boolean :recipient_delete, default: false
  t.boolean :sender_delete, default: false
  t.boolean :recipient_permanent_delete, default: false
  t.boolean :sender_permanent_delete, default: false
  t.datetime :opened_at, :datetime
  t.string :ancestry
  t.timestamps
end, T.untyped)

USER_SCHEMA = T.let(lambda do |t|
  t.string :email
end, T.untyped)
