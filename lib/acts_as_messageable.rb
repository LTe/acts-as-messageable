# typed: strong
# frozen_string_literal: true

require 'zeitwerk'
require 'sorbet-runtime'
require 'sorbet-rails'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: true)
loader.ignore("#{__dir__}/generators")
loader.setup

module ActsAsMessageable
end

require 'acts_as_messageable/railtie'
