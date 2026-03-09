# typed: true
# frozen_string_literal: true

# Needed for ancestry in order to generate types.
# Requires ancestry explicitly and fires the ActiveSupport on_load hooks so
# that tapioca can introspect Ancestry's dynamically-loaded modules.
require 'active_support'
require 'active_record'
require 'ancestry'
ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
