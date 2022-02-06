# typed: strong
# typed: false
# frozen_string_literal: true
module ActsAsMessageable
  # _@return_ — API wrapper
  sig { returns(T.any(T.class_of(ActsAsMessageable::Rails4), T.class_of(ActsAsMessageable::Rails6), T.class_of(ActsAsMessageable::Rails3))) }
  def self.rails_api; end

  module Model
    # _@param_ `base`
    sig { params(base: Object).returns(Object) }
    def self.included(base); end

    module ClassMethods
      # Method make ActiveRecord::Base object messageable
      # 
      # _@param_ `options`
      sig { params(options: T::Hash[T.untyped, T.untyped]).returns(Object) }
      def acts_as_messageable(options = {}); end

      # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
      # Method recognize real object class
      # 
      # _@return_ — class or relation object
      sig { returns(ActiveRecord::Base) }
      def resolve_active_record_ancestor; end
    end

    module InstanceMethods
      # sord warn - ActiveRecord::Relation wasn't able to be resolved to a constant in this project
      # _@param_ `trash` — Show deleted messages
      # 
      # _@return_ — all messages connected with user
      sig { params(trash: T::Boolean).returns(ActiveRecord::Relation) }
      def messages(trash = false); end

      # sord warn - ActiveRecord::Relation wasn't able to be resolved to a constant in this project
      # _@return_ — returns all messages from inbox
      sig { returns(ActiveRecord::Relation) }
      def received_messages; end

      # sord warn - ActiveRecord::Relation wasn't able to be resolved to a constant in this project
      # _@return_ — returns all messages from outbox
      sig { returns(ActiveRecord::Relation) }
      def sent_messages; end

      # sord warn - ActiveRecord::Relation wasn't able to be resolved to a constant in this project
      # _@return_ — returns all messages from trash
      sig { returns(ActiveRecord::Relation) }
      def deleted_messages; end

      # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
      # Method sends message to another user
      # 
      # _@param_ `to`
      # 
      # _@param_ `args`
      # 
      # _@return_ — the message object
      sig { params(to: ActiveRecord::Base, args: T::Hash[T.untyped, T.untyped]).returns(ActsAsMessageable::Message) }
      def send_message(to, *args); end

      # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
      # Method send message to another user
      # and raise exception in case of validation errors
      # 
      # _@param_ `to`
      # 
      # _@param_ `args`
      # 
      # _@return_ — the message object
      sig { params(to: ActiveRecord::Base, args: T::Hash[T.untyped, T.untyped]).returns(ActsAsMessageable::Message) }
      def send_message!(to, *args); end

      # Reply to given message
      # 
      # _@param_ `message`
      # 
      # _@param_ `args`
      # 
      # _@return_ — a message that is a response to a given message
      sig { params(message: ActsAsMessageable::Message, args: T::Hash[T.untyped, T.untyped]).returns(ActsAsMessageable::Message) }
      def reply_to(message, *args); end

      # Mark message as deleted
      # 
      # _@param_ `message` — to delete
      # 
      # _@return_ — deleted message
      sig { params(message: ActsAsMessageable::Message).returns(ActsAsMessageable::Message) }
      def delete_message(message); end

      # Mark message as restored
      # 
      # _@param_ `message` — to restore
      # 
      # _@return_ — restored message
      sig { params(message: ActsAsMessageable::Message).returns(ActsAsMessageable::Message) }
      def restore_message(message); end
    end
  end

  class Rails3
    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # _@param_ `subject`
    # 
    # _@return_ — api wrapper object
    sig { params(subject: ActiveRecord::Base).void }
    def initialize(subject); end

    # _@param_ `order_by`
    # 
    # _@see_ `ActiveRecord::Base#default_scope`
    sig { params(order_by: T.any(String, Symbol)).returns(Object) }
    def default_scope(order_by); end

    # _@param_ `name`
    # 
    # _@param_ `args`
    sig { params(name: Symbol, args: T::Array[T.untyped]).returns(Object) }
    def method_missing(name, *args); end

    # _@param_ `method_name`
    # 
    # _@param_ `include_private`
    sig { params(method_name: Object, include_private: FalseClass).returns(T::Boolean) }
    def respond_to_missing?(method_name, include_private = false); end
  end

  class Rails4
    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # _@param_ `subject`
    # 
    # _@return_ — api wrapper object
    sig { params(subject: ActiveRecord::Base).void }
    def initialize(subject); end

    # Empty method for Rails 4.x
    sig { returns(NilClass) }
    def attr_accessible; end

    # Default scope for Rails 4.x with block support
    # 
    # _@param_ `order_by`
    sig { params(order_by: T.any(String, Symbol)).returns(Object) }
    def default_scope(order_by); end

    # Rename of the method
    sig { returns(Object) }
    def scoped; end

    # _@param_ `name`
    # 
    # _@param_ `args`
    sig { params(name: Symbol, args: T::Array[T.untyped]).returns(Object) }
    def method_missing(name, *args); end

    # _@param_ `method_name`
    # 
    # _@param_ `include_private`
    sig { params(method_name: String, include_private: T::Boolean).returns(T::Boolean) }
    def respond_to_missing?(method_name, include_private = false); end
  end

  class Rails6
    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # _@param_ `subject`
    # 
    # _@return_ — api wrapper object
    sig { params(subject: ActiveRecord::Base).void }
    def initialize(subject); end

    # Empty method for Rails 3.x
    sig { returns(NilClass) }
    def attr_accessible; end

    # Default scope for Rails 6.x with block support
    # 
    # _@param_ `order_by`
    sig { params(order_by: T.any(String, Symbol)).returns(Object) }
    def default_scope(order_by); end

    # Rename of the method
    sig { returns(Object) }
    def scoped; end

    # Use new method #update! in Rails 6.x
    # 
    # _@param_ `args`
    sig { params(args: T::Array[T.untyped]).returns(Object) }
    def update_attributes!(*args); end

    # _@param_ `name`
    # 
    # _@param_ `args`
    sig { params(name: Symbol, args: T::Array[T.untyped]).returns(Object) }
    def method_missing(name, *args); end

    # _@param_ `method_name`
    # 
    # _@param_ `include_private`
    sig { params(method_name: String, include_private: T::Boolean).returns(T::Boolean) }
    def respond_to_missing?(method_name, include_private = false); end
  end

  module Scopes
    extend ActiveSupport::Concern

    module ClassMethods
      # _@param_ `search_scope`
      sig { params(search_scope: T.any(String, Symbol)).returns(Object) }
      def initialize_scopes(search_scope); end
    end
  end

  class Message < ActiveRecord::Base
    include ActsAsMessageable::Scopes

    # _@return_ — whether the message has been read
    sig { returns(T::Boolean) }
    def open?; end

    # _@return_ — whether the message has been read
    # 
    # _@see_ `open?`
    sig { returns(T::Boolean) }
    def opened?; end

    # Method open message (will mark message as read)
    # 
    # _@return_ — current message
    sig { returns(ActsAsMessageable::Message) }
    def open; end

    # Method close message (will mark message as unread)
    # 
    # _@return_ — current message
    sig { returns(ActsAsMessageable::Message) }
    def close; end

    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # sord warn - ActiveRecord::Associations::BelongsToAssociation wasn't able to be resolved to a constant in this project
    # _@param_ `user`
    # 
    # _@return_ — real receiver of the mssage
    sig { params(user: ActiveRecord::Base).returns(ActiveRecord::Associations::BelongsToAssociation) }
    def real_receiver(user); end

    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # _@param_ `user`
    # 
    # _@return_ — whether user is participant of group message
    sig { params(user: ActiveRecord::Base).returns(T::Boolean) }
    def participant?(user); end

    # _@return_ — conversation tree
    sig { returns(Object) }
    def conversation; end

    # Method will mark message as removed
    sig { returns(TrueClass) }
    def delete; end

    # Method will mark message as removed
    sig { returns(TrueClass) }
    def restore; end

    # Reply to given message
    # 
    # _@param_ `args`
    # 
    # _@return_ — a message that is a response to a given message
    # 
    # _@see_ `ActsAsMessageable::Model::InstanceMethods#reply_to`
    sig { params(args: T::Hash[T.untyped, T.untyped]).returns(ActsAsMessageable::Message) }
    def reply(*args); end

    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # Method will return list of users in the conversation
    # 
    # _@return_ — users
    sig { returns(T::Array[ActiveRecord::Base]) }
    def people; end

    # Returns the value of attribute removed.
    sig { returns(T.untyped) }
    attr_accessor :removed

    # Returns the value of attribute restored.
    sig { returns(T.untyped) }
    attr_accessor :restored
  end

  class Railtie < Rails::Railtie
  end

  module Relation
    # sord warn - ActiveRecord::Base wasn't able to be resolved to a constant in this project
    # sord warn - ActiveRecord::Relation wasn't able to be resolved to a constant in this project
    # _@param_ `context` — of relation (most of the time current_user object)
    sig { params(context: ActiveRecord::Base).returns(ActiveRecord::Relation) }
    def process(context = relation_context); end

    sig { returns(T::Array[ActsAsMessageable::Message]) }
    def conversations; end

    # Returns the value of attribute relation_context.
    sig { returns(T.untyped) }
    attr_accessor :relation_context
  end

  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    # sord omit - no YARD type given for "dirname", using untyped
    # sord omit - no YARD return type given, using untyped
    sig { params(dirname: T.untyped).returns(T.untyped) }
    def self.next_migration_number(dirname); end

    # sord omit - no YARD return type given, using untyped
    sig { returns(T.untyped) }
    def create_migration_file; end
  end
end
