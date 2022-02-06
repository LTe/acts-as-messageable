# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rchardet/all/rchardet.rbi
#
# rchardet-1.8.0

module CharDet
  def self.detect(aBuf); end
end
class CharDet::CharSetProber
  def active; end
  def active=(arg0); end
  def feed(aBuf); end
  def filter_high_bit_only(aBuf); end
  def filter_with_english_letters(aBuf); end
  def filter_without_english_letters(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def get_state; end
  def initialize; end
  def reset; end
end
class CharDet::MultiByteCharSetProber < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
class CharDet::Big5Prober < CharDet::MultiByteCharSetProber
  def get_charset_name; end
  def initialize; end
end
class CharDet::CharDistributionAnalysis
  def feed(aStr, aCharLen); end
  def get_confidence; end
  def get_order(aStr); end
  def got_enough_data; end
  def initialize; end
  def reset; end
end
class CharDet::EUCTWDistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_confidence; end
  def get_order(aStr); end
  def initialize; end
end
class CharDet::EUCKRDistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_order(aStr); end
  def initialize; end
end
class CharDet::GB18030DistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_order(aStr); end
  def initialize; end
end
class CharDet::Big5DistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_order(aStr); end
  def initialize; end
end
class CharDet::SJISDistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_order(aStr); end
  def initialize; end
end
class CharDet::EUCJPDistributionAnalysis < CharDet::CharDistributionAnalysis
  def get_order(aStr); end
  def initialize; end
end
class CharDet::CharSetGroupProber < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def probers; end
  def probers=(arg0); end
  def reset; end
end
class CharDet::CodingStateMachine
  def active; end
  def active=(arg0); end
  def get_coding_state_machine; end
  def get_current_charlen; end
  def initialize(sm); end
  def next_state(c); end
  def reset; end
end
class CharDet::EscCharSetProber < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
class CharDet::EUCJPProber < CharDet::MultiByteCharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
class CharDet::EUCKRProber < CharDet::MultiByteCharSetProber
  def get_charset_name; end
  def initialize; end
end
class CharDet::EUCTWProber < CharDet::MultiByteCharSetProber
  def get_charset_name; end
  def initialize; end
end
class CharDet::GB18030Prober < CharDet::MultiByteCharSetProber
  def get_charset_name; end
  def initialize; end
end
class CharDet::HebrewProber < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_state; end
  def initialize; end
  def is_final(c); end
  def is_non_final(c); end
  def reset; end
  def set_model_probers(logicalProber, visualProber); end
end
class CharDet::JapaneseContextAnalysis
  def feed(aBuf, aLen); end
  def get_confidence; end
  def get_order(aStr); end
  def got_enough_data; end
  def initialize; end
  def reset; end
end
class CharDet::SJISContextAnalysis < CharDet::JapaneseContextAnalysis
  def get_order(aStr); end
end
class CharDet::EUCJPContextAnalysis < CharDet::JapaneseContextAnalysis
  def get_order(aStr); end
end
class CharDet::Latin1Prober < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
class CharDet::MBCSGroupProber < CharDet::CharSetGroupProber
  def initialize; end
end
class CharDet::SingleByteCharSetProber < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize(model, reversed = nil, nameProber = nil); end
  def reset; end
end
class CharDet::SBCSGroupProber < CharDet::CharSetGroupProber
  def initialize; end
end
class CharDet::SJISProber < CharDet::MultiByteCharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
class CharDet::UniversalDetector
  def close; end
  def done; end
  def feed(aBuf); end
  def initialize; end
  def reset; end
  def result; end
end
class CharDet::UTF8Prober < CharDet::CharSetProber
  def feed(aBuf); end
  def get_charset_name; end
  def get_confidence; end
  def initialize; end
  def reset; end
end
