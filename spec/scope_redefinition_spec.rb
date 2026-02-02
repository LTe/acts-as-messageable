# typed: false
# frozen_string_literal: true

require 'spec_helper'

describe 'Scope Redefinition' do
  before do
    User.acts_as_messageable
  end

  it 'does not produce warnings when initialize_scopes is called multiple times' do
    # Enable warnings to catch any scope redefinition warnings
    original_verbose = $VERBOSE
    $VERBOSE = true

    # Capture warnings
    warnings = []
    original_warn = Kernel.instance_method(:warn)

    Kernel.define_method(:warn) do |*args|
      warnings << args.join(' ')
      original_warn.bind_call(self, *args)
    end

    begin
      # Call initialize_scopes multiple times
      # This simulates what happens in development mode with class reloading
      User.messages_class_name.initialize_scopes(:search)
      User.messages_class_name.initialize_scopes(:search)
      User.messages_class_name.initialize_scopes(:search)

      # Check that no warnings about overwriting scopes were produced
      scope_warnings = warnings.select do |w|
        w.include?('Overwriting existing method') || w.include?('Creating scope')
      end

      expect(scope_warnings).to be_empty,
                                "Expected no scope redefinition warnings, but got: #{scope_warnings.join("\n")}"
    ensure
      # Restore original warn method
      Kernel.define_method(:warn, original_warn)
      $VERBOSE = original_verbose
    end
  end

  it 'keeps scopes functional after multiple initialization calls' do
    # Call initialize_scopes multiple times
    User.messages_class_name.initialize_scopes(:search)
    User.messages_class_name.initialize_scopes(:search)

    # Create test messages
    send_message(@bob, @alice, 'Topic 1', 'Body 1')
    message2 = send_message(@bob, @alice, 'Topic 2', 'Body 2')
    message2.open

    # Test that scopes still work correctly
    expect(@alice.messages.readed.count).to eq(1)
    expect(@alice.messages.unreaded.count).to eq(1)
  end
end
