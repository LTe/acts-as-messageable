# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `securerandom` gem.
# Please instead update this file by running `bin/tapioca gem securerandom`.


class Random::Base
  include ::Random::Formatter
  extend ::Random::Formatter

  def initialize(*_arg0); end

  def bytes(_arg0); end
  def rand(*_arg0); end
  def seed; end
end

module Random::Formatter
  def alphanumeric(n = T.unsafe(nil), chars: T.unsafe(nil)); end
  def base64(n = T.unsafe(nil)); end
  def hex(n = T.unsafe(nil)); end
  def random_bytes(n = T.unsafe(nil)); end
  def urlsafe_base64(n = T.unsafe(nil), padding = T.unsafe(nil)); end
  def uuid; end
  def uuid_v4; end
  def uuid_v7(extra_timestamp_bits: T.unsafe(nil)); end

  private

  def choose(source, n); end
  def gen_random(n); end
end

module SecureRandom
  extend ::Random::Formatter

  class << self
    def bytes(n); end
    def gen_random(n); end

    private

    def gen_random_openssl(n); end
    def gen_random_urandom(n); end
  end
end

SecureRandom::VERSION = T.let(T.unsafe(nil), String)
