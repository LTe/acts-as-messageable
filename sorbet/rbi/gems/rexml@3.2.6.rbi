# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rexml` gem.
# Please instead update this file by running `bin/tapioca gem rexml`.

module REXML::Encoding
  def decode(string); end
  def encode(string); end
  def encoding; end
  def encoding=(encoding); end

  private

  def find_encoding(name); end
end

class REXML::IOSource < ::REXML::Source
  def initialize(arg, block_size = T.unsafe(nil), encoding = T.unsafe(nil)); end

  def consume(pattern); end
  def current_line; end
  def empty?; end
  def match(pattern, cons = T.unsafe(nil)); end
  def position; end
  def read; end
  def scan(pattern, cons = T.unsafe(nil)); end

  private

  def encoding_updated; end
  def readline; end
end

class REXML::ParseException < ::RuntimeError
  def initialize(message, source = T.unsafe(nil), parser = T.unsafe(nil), exception = T.unsafe(nil)); end

  def context; end
  def continued_exception; end
  def continued_exception=(_arg0); end
  def line; end
  def parser; end
  def parser=(_arg0); end
  def position; end
  def source; end
  def source=(_arg0); end
  def to_s; end
end

class REXML::Parsers::BaseParser
  def initialize(source); end

  def add_listener(listener); end
  def empty?; end
  def entity(reference, entities); end
  def has_next?; end
  def normalize(input, entities = T.unsafe(nil), entity_filter = T.unsafe(nil)); end
  def peek(depth = T.unsafe(nil)); end
  def position; end
  def pull; end
  def source; end
  def stream=(source); end
  def unnormalize(string, entities = T.unsafe(nil), filter = T.unsafe(nil)); end
  def unshift(token); end

  private

  def need_source_encoding_update?(xml_declaration_encoding); end
  def parse_attributes(prefixes, curr_ns); end
  def parse_id(base_error_message, accept_external_id:, accept_public_id:); end
  def parse_id_invalid_details(accept_external_id:, accept_public_id:); end
  def parse_name(base_error_message); end
  def process_instruction; end
  def pull_event; end
end

REXML::Parsers::BaseParser::EXTERNAL_ID_PUBLIC = T.let(T.unsafe(nil), Regexp)
REXML::Parsers::BaseParser::EXTERNAL_ID_SYSTEM = T.let(T.unsafe(nil), Regexp)
REXML::Parsers::BaseParser::PUBLIC_ID = T.let(T.unsafe(nil), Regexp)
REXML::Parsers::BaseParser::QNAME = T.let(T.unsafe(nil), Regexp)
REXML::Parsers::BaseParser::QNAME_STR = T.let(T.unsafe(nil), String)

class REXML::Source
  include ::REXML::Encoding

  def initialize(arg, encoding = T.unsafe(nil)); end

  def buffer; end
  def consume(pattern); end
  def current_line; end
  def empty?; end
  def encoding; end
  def encoding=(enc); end
  def line; end
  def match(pattern, cons = T.unsafe(nil)); end
  def match_to(char, pattern); end
  def match_to_consume(char, pattern); end
  def position; end
  def read; end
  def scan(pattern, cons = T.unsafe(nil)); end

  private

  def detect_encoding; end
  def encoding_updated; end
end

class REXML::UndefinedNamespaceException < ::REXML::ParseException
  def initialize(prefix, source, parser); end
end
