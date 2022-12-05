# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rchardet` gem.
# Please instead update this file by running `bin/tapioca gem rchardet`.

# source://rchardet//lib/rchardet/version.rb#1
module CharDet
  class << self
    # source://rchardet//lib/rchardet.rb#58
    def detect(aBuf); end
  end
end

# accent capital other
#
# source://rchardet//lib/rchardet/latin1prober.rb#38
CharDet::ACO = T.let(T.unsafe(nil), Integer)

# accent capital vowel
#
# source://rchardet//lib/rchardet/latin1prober.rb#37
CharDet::ACV = T.let(T.unsafe(nil), Integer)

# ascii capital letter
#
# source://rchardet//lib/rchardet/latin1prober.rb#35
CharDet::ASC = T.let(T.unsafe(nil), Integer)

# accent small other
#
# source://rchardet//lib/rchardet/latin1prober.rb#40
CharDet::ASO = T.let(T.unsafe(nil), Integer)

# ascii small letter
#
# source://rchardet//lib/rchardet/latin1prober.rb#36
CharDet::ASS = T.let(T.unsafe(nil), Integer)

# accent small vowel
#
# source://rchardet//lib/rchardet/latin1prober.rb#39
CharDet::ASV = T.let(T.unsafe(nil), Integer)

# Char to FreqOrder table
#
# source://rchardet//lib/rchardet/big5freq.rb#48
CharDet::BIG5_TABLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/big5freq.rb#45
CharDet::BIG5_TYPICAL_DISTRIBUTION_RATIO = T.let(T.unsafe(nil), Float)

# BIG5
#
# source://rchardet//lib/rchardet/mbcssm.rb#32
CharDet::BIG5_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#67
CharDet::BIG5_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#73
CharDet::Big5CharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/big5freq.rb#50
CharDet::Big5CharToFreqOrder = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/chardistribution.rb#174
class CharDet::Big5DistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [Big5DistributionAnalysis] a new instance of Big5DistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#175
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#182
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/big5prober.rb#30
class CharDet::Big5Prober < ::CharDet::MultiByteCharSetProber
  # @return [Big5Prober] a new instance of Big5Prober
  #
  # source://rchardet//lib/rchardet/big5prober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/big5prober.rb#38
  def get_charset_name; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#75
CharDet::Big5SMModel = T.let(T.unsafe(nil), Hash)

# Model Table:
# total sequences: 100%
# first 512 sequences: 96.9392%
# first 1024 sequences:3.0618%
# rest  sequences:     0.2992%
# negative sequences:  0.0020%
#
# source://rchardet//lib/rchardet/langbulgarianmodel.rb#83
CharDet::BulgarianLangModel = T.let(T.unsafe(nil), Array)

# total classes
#
# source://rchardet//lib/rchardet/latin1prober.rb#41
CharDet::CLASS_NUM = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/chardistribution.rb#34
class CharDet::CharDistributionAnalysis
  # @return [CharDistributionAnalysis] a new instance of CharDistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#35
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#49
  def feed(aStr, aCharLen); end

  # source://rchardet//lib/rchardet/chardistribution.rb#68
  def get_confidence; end

  # source://rchardet//lib/rchardet/chardistribution.rb#92
  def get_order(aStr); end

  # source://rchardet//lib/rchardet/chardistribution.rb#86
  def got_enough_data; end

  # source://rchardet//lib/rchardet/chardistribution.rb#42
  def reset; end
end

# source://rchardet//lib/rchardet/charsetgroupprober.rb#30
class CharDet::CharSetGroupProber < ::CharDet::CharSetProber
  # @return [CharSetGroupProber] a new instance of CharSetGroupProber
  #
  # source://rchardet//lib/rchardet/charsetgroupprober.rb#32
  def initialize; end

  # source://rchardet//lib/rchardet/charsetgroupprober.rb#63
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/charsetgroupprober.rb#53
  def get_charset_name; end

  # source://rchardet//lib/rchardet/charsetgroupprober.rb#84
  def get_confidence; end

  # Returns the value of attribute probers.
  #
  # source://rchardet//lib/rchardet/charsetgroupprober.rb#31
  def probers; end

  # Sets the attribute probers
  #
  # @param value the value to set the attribute probers to.
  #
  # source://rchardet//lib/rchardet/charsetgroupprober.rb#31
  def probers=(_arg0); end

  # source://rchardet//lib/rchardet/charsetgroupprober.rb#39
  def reset; end
end

# source://rchardet//lib/rchardet/charsetprober.rb#31
class CharDet::CharSetProber
  # @return [CharSetProber] a new instance of CharSetProber
  #
  # source://rchardet//lib/rchardet/charsetprober.rb#33
  def initialize; end

  # Returns the value of attribute active.
  #
  # source://rchardet//lib/rchardet/charsetprober.rb#32
  def active; end

  # Sets the attribute active
  #
  # @param value the value to set the attribute active to.
  #
  # source://rchardet//lib/rchardet/charsetprober.rb#32
  def active=(_arg0); end

  # source://rchardet//lib/rchardet/charsetprober.rb#44
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/charsetprober.rb#55
  def filter_high_bit_only(aBuf); end

  # source://rchardet//lib/rchardet/charsetprober.rb#65
  def filter_with_english_letters(aBuf); end

  # source://rchardet//lib/rchardet/charsetprober.rb#60
  def filter_without_english_letters(aBuf); end

  # source://rchardet//lib/rchardet/charsetprober.rb#40
  def get_charset_name; end

  # source://rchardet//lib/rchardet/charsetprober.rb#51
  def get_confidence; end

  # source://rchardet//lib/rchardet/charsetprober.rb#47
  def get_state; end

  # source://rchardet//lib/rchardet/charsetprober.rb#36
  def reset; end
end

# source://rchardet//lib/rchardet/codingstatemachine.rb#30
class CharDet::CodingStateMachine
  # @return [CodingStateMachine] a new instance of CodingStateMachine
  #
  # source://rchardet//lib/rchardet/codingstatemachine.rb#33
  def initialize(sm); end

  # Returns the value of attribute active.
  #
  # source://rchardet//lib/rchardet/codingstatemachine.rb#31
  def active; end

  # Sets the attribute active
  #
  # @param value the value to set the attribute active to.
  #
  # source://rchardet//lib/rchardet/codingstatemachine.rb#31
  def active=(_arg0); end

  # source://rchardet//lib/rchardet/codingstatemachine.rb#63
  def get_coding_state_machine; end

  # source://rchardet//lib/rchardet/codingstatemachine.rb#59
  def get_current_charlen; end

  # source://rchardet//lib/rchardet/codingstatemachine.rb#44
  def next_state(c); end

  # source://rchardet//lib/rchardet/codingstatemachine.rb#40
  def reset; end
end

# source://rchardet//lib/rchardet/jpcntx.rb#31
CharDet::DONT_KNOW = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#33
CharDet::EDetecting = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#38
CharDet::EError = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/universaldetector.rb#35
CharDet::EEscAscii = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#34
CharDet::EFoundIt = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/universaldetector.rb#36
CharDet::EHighbyte = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#39
CharDet::EItsMe = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/chardistribution.rb#30
CharDet::ENOUGH_DATA_THRESHOLD = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/jpcntx.rb#32
CharDet::ENOUGH_REL_THRESHOLD = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#35
CharDet::ENotMe = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/universaldetector.rb#34
CharDet::EPureAscii = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#37
CharDet::EStart = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/mbcssm.rb#127
CharDet::EUCJPCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/jpcntx.rb#205
class CharDet::EUCJPContextAnalysis < ::CharDet::JapaneseContextAnalysis
  # source://rchardet//lib/rchardet/jpcntx.rb#206
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/chardistribution.rb#229
class CharDet::EUCJPDistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [EUCJPDistributionAnalysis] a new instance of EUCJPDistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#230
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#237
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/eucjpprober.rb#30
class CharDet::EUCJPProber < ::CharDet::MultiByteCharSetProber
  # @return [EUCJPProber] a new instance of EUCJPProber
  #
  # source://rchardet//lib/rchardet/eucjpprober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/eucjpprober.rb#48
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/eucjpprober.rb#44
  def get_charset_name; end

  # source://rchardet//lib/rchardet/eucjpprober.rb#83
  def get_confidence; end

  # source://rchardet//lib/rchardet/eucjpprober.rb#39
  def reset; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#129
CharDet::EUCJPSMModel = T.let(T.unsafe(nil), Hash)

# EUC-JP
#
# source://rchardet//lib/rchardet/mbcssm.rb#84
CharDet::EUCJP_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#119
CharDet::EUCJP_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#178
CharDet::EUCKRCharLenTable = T.let(T.unsafe(nil), Array)

# Char to FreqOrder table ,
#
# source://rchardet//lib/rchardet/euckrfreq.rb#47
CharDet::EUCKRCharToFreqOrder = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/chardistribution.rb#130
class CharDet::EUCKRDistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [EUCKRDistributionAnalysis] a new instance of EUCKRDistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#131
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#138
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/euckrprober.rb#30
class CharDet::EUCKRProber < ::CharDet::MultiByteCharSetProber
  # @return [EUCKRProber] a new instance of EUCKRProber
  #
  # source://rchardet//lib/rchardet/euckrprober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/euckrprober.rb#38
  def get_charset_name; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#180
CharDet::EUCKRSMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/euckrfreq.rb#44
CharDet::EUCKR_TABLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/euckrfreq.rb#42
CharDet::EUCKR_TYPICAL_DISTRIBUTION_RATIO = T.let(T.unsafe(nil), Float)

# EUC-KR
#
# source://rchardet//lib/rchardet/mbcssm.rb#138
CharDet::EUCKR_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#173
CharDet::EUCKR_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#233
CharDet::EUCTWCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/euctwfreq.rb#52
CharDet::EUCTWCharToFreqOrder = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/chardistribution.rb#100
class CharDet::EUCTWDistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [EUCTWDistributionAnalysis] a new instance of EUCTWDistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#101
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#121
  def get_confidence; end

  # source://rchardet//lib/rchardet/chardistribution.rb#108
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/euctwprober.rb#30
class CharDet::EUCTWProber < ::CharDet::MultiByteCharSetProber
  # @return [EUCTWProber] a new instance of EUCTWProber
  #
  # source://rchardet//lib/rchardet/euctwprober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/euctwprober.rb#38
  def get_charset_name; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#235
CharDet::EUCTWSMModel = T.let(T.unsafe(nil), Hash)

# Char to FreqOrder table ,
#
# source://rchardet//lib/rchardet/euctwfreq.rb#50
CharDet::EUCTW_TABLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/euctwfreq.rb#47
CharDet::EUCTW_TYPICAL_DISTRIBUTION_RATIO = T.let(T.unsafe(nil), Float)

# EUC-TW
#
# source://rchardet//lib/rchardet/mbcssm.rb#189
CharDet::EUCTW_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#224
CharDet::EUCTW_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escprober.rb#30
class CharDet::EscCharSetProber < ::CharDet::CharSetProber
  # @return [EscCharSetProber] a new instance of EscCharSetProber
  #
  # source://rchardet//lib/rchardet/escprober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/escprober.rb#65
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/escprober.rb#53
  def get_charset_name; end

  # source://rchardet//lib/rchardet/escprober.rb#57
  def get_confidence; end

  # source://rchardet//lib/rchardet/escprober.rb#42
  def reset; end
end

# source://rchardet//lib/rchardet/hebrewprober.rb#128
CharDet::FINAL_KAF = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#130
CharDet::FINAL_MEM = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#132
CharDet::FINAL_NUN = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#134
CharDet::FINAL_PE = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#136
CharDet::FINAL_TSADI = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/latin1prober.rb#31
CharDet::FREQ_CAT_NUM = T.let(T.unsafe(nil), Integer)

# To be accurate, the length of class 6 can be either 2 or 4.
# But it is not necessary to discriminate between the two since
# it is used for frequency analysis only, and we are validing
# each code range there as well. So it is safe to set it to be
# 2 here.
#
# source://rchardet//lib/rchardet/mbcssm.rb#293
CharDet::GB18030CharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/gb18030freq.rb#48
CharDet::GB18030CharToFreqOrder = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/chardistribution.rb#152
class CharDet::GB18030DistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [GB18030DistributionAnalysis] a new instance of GB18030DistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#153
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#160
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/gb18030prober.rb#30
class CharDet::GB18030Prober < ::CharDet::MultiByteCharSetProber
  # @return [GB18030Prober] a new instance of GB18030Prober
  #
  # source://rchardet//lib/rchardet/gb18030prober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/gb18030prober.rb#38
  def get_charset_name; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#295
CharDet::GB18030SMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/gb18030freq.rb#46
CharDet::GB18030_TABLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/gb18030freq.rb#44
CharDet::GB18030_TYPICAL_DISTRIBUTION_RATIO = T.let(T.unsafe(nil), Float)

# GB18030
#
# source://rchardet//lib/rchardet/mbcssm.rb#244
CharDet::GB18030_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#279
CharDet::GB18030_st = T.let(T.unsafe(nil), Array)

# Model Table:
# total sequences: 100%
# first 512 sequences: 98.2851%
# first 1024 sequences:1.7001%
# rest  sequences:     0.0359%
# negative sequences:  0.0148%
#
# source://rchardet//lib/rchardet/langgreekmodel.rb#81
CharDet::GreekLangModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#74
CharDet::HZCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#76
CharDet::HZSMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/escsm.rb#30
CharDet::HZ_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#65
CharDet::HZ_st = T.let(T.unsafe(nil), Array)

# Model Table:
# total sequences: 100%
# first 512 sequences: 98.4004%
# first 1024 sequences: 1.5981%
# rest  sequences:      0.087%
# negative sequences:   0.0015%
#
# source://rchardet//lib/rchardet/langhebrewmodel.rb#64
CharDet::HebrewLangModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/hebrewprober.rb#150
class CharDet::HebrewProber < ::CharDet::CharSetProber
  # @return [HebrewProber] a new instance of HebrewProber
  #
  # source://rchardet//lib/rchardet/hebrewprober.rb#151
  def initialize; end

  # source://rchardet//lib/rchardet/hebrewprober.rb#192
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/hebrewprober.rb#252
  def get_charset_name; end

  # source://rchardet//lib/rchardet/hebrewprober.rb#281
  def get_state; end

  # source://rchardet//lib/rchardet/hebrewprober.rb#174
  def is_final(c); end

  # source://rchardet//lib/rchardet/hebrewprober.rb#178
  def is_non_final(c); end

  # source://rchardet//lib/rchardet/hebrewprober.rb#158
  def reset; end

  # source://rchardet//lib/rchardet/hebrewprober.rb#169
  def set_model_probers(logicalProber, visualProber); end
end

# Model Table:
# total sequences: 100%
# first 512 sequences: 94.7368%
# first 1024 sequences:5.2623%
# rest  sequences:     0.8894%
# negative sequences:  0.0009%
#
# source://rchardet//lib/rchardet/langhungarianmodel.rb#80
CharDet::HungarianLangModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#108
CharDet::IBM855_CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#127
CharDet::IBM866_CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#129
CharDet::ISO2022CNCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#131
CharDet::ISO2022CNSMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/escsm.rb#83
CharDet::ISO2022CN_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#118
CharDet::ISO2022CN_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#185
CharDet::ISO2022JPCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#187
CharDet::ISO2022JPSMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/escsm.rb#138
CharDet::ISO2022JP_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#173
CharDet::ISO2022JP_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#237
CharDet::ISO2022KRCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#239
CharDet::ISO2022KRSMModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/escsm.rb#194
CharDet::ISO2022KR_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/escsm.rb#229
CharDet::ISO2022KR_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#323
CharDet::Ibm855Model = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#315
CharDet::Ibm866Model = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/jisfreq.rb#51
CharDet::JISCharToFreqOrder = T.let(T.unsafe(nil), Array)

# Char to FreqOrder table ,
#
# source://rchardet//lib/rchardet/jisfreq.rb#49
CharDet::JIS_TABLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/jisfreq.rb#46
CharDet::JIS_TYPICAL_DISTRIBUTION_RATIO = T.let(T.unsafe(nil), Float)

# This is hiragana 2-char sequence table, the number in each cell represents its frequency category
#
# source://rchardet//lib/rchardet/jpcntx.rb#36
CharDet::JP2_CHAR_CONTEXT = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/jpcntx.rb#122
class CharDet::JapaneseContextAnalysis
  # @return [JapaneseContextAnalysis] a new instance of JapaneseContextAnalysis
  #
  # source://rchardet//lib/rchardet/jpcntx.rb#123
  def initialize; end

  # source://rchardet//lib/rchardet/jpcntx.rb#135
  def feed(aBuf, aLen); end

  # source://rchardet//lib/rchardet/jpcntx.rb#169
  def get_confidence; end

  # source://rchardet//lib/rchardet/jpcntx.rb#178
  def get_order(aStr); end

  # source://rchardet//lib/rchardet/jpcntx.rb#165
  def got_enough_data; end

  # source://rchardet//lib/rchardet/jpcntx.rb#127
  def reset; end
end

# Character Mapping Table:
#
# source://rchardet//lib/rchardet/langcyrillicmodel.rb#32
CharDet::KOI8R_CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#283
CharDet::Koi8rModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/hebrewprober.rb#148
CharDet::LOGICAL_HEBREW_NAME = T.let(T.unsafe(nil), String)

# 0 : illegal
# 1 : very unlikely
# 2 : normal
# 3 : very likely
#
# source://rchardet//lib/rchardet/latin1prober.rb#82
CharDet::Latin1ClassModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/latin1prober.rb#94
class CharDet::Latin1Prober < ::CharDet::CharSetProber
  # @return [Latin1Prober] a new instance of Latin1Prober
  #
  # source://rchardet//lib/rchardet/latin1prober.rb#95
  def initialize; end

  # source://rchardet//lib/rchardet/latin1prober.rb#110
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/latin1prober.rb#106
  def get_charset_name; end

  # source://rchardet//lib/rchardet/latin1prober.rb#127
  def get_confidence; end

  # source://rchardet//lib/rchardet/latin1prober.rb#100
  def reset; end
end

# source://rchardet//lib/rchardet/latin1prober.rb#43
CharDet::Latin1_CharToClass = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langhungarianmodel.rb#211
CharDet::Latin2HungarianModel = T.let(T.unsafe(nil), Hash)

# Character Mapping Table:
#
# source://rchardet//lib/rchardet/langhungarianmodel.rb#36
CharDet::Latin2_HungarianCharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langbulgarianmodel.rb#214
CharDet::Latin5BulgarianModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#299
CharDet::Latin5CyrillicModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langbulgarianmodel.rb#39
CharDet::Latin5_BulgarianCharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langgreekmodel.rb#212
CharDet::Latin7GreekModel = T.let(T.unsafe(nil), Hash)

# Character Mapping Table:
#
# source://rchardet//lib/rchardet/langgreekmodel.rb#37
CharDet::Latin7_CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/jpcntx.rb#33
CharDet::MAX_REL_THRESHOLD = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/mbcsgroupprober.rb#32
class CharDet::MBCSGroupProber < ::CharDet::CharSetGroupProber
  # @return [MBCSGroupProber] a new instance of MBCSGroupProber
  #
  # source://rchardet//lib/rchardet/mbcsgroupprober.rb#33
  def initialize; end
end

# source://rchardet//lib/rchardet/universaldetector.rb#32
CharDet::MINIMUM_DATA_THRESHOLD = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/universaldetector.rb#33
CharDet::MINIMUM_THRESHOLD = T.let(T.unsafe(nil), Float)

# Minimum Visual vs Logical final letter score difference.
# If the difference is below this, don't rely solely on the final letter score distance.
#
# source://rchardet//lib/rchardet/hebrewprober.rb#141
CharDet::MIN_FINAL_CHAR_DISTANCE = T.let(T.unsafe(nil), Integer)

# Minimum Visual vs Logical model score difference.
# If the difference is below this, don't rely at all on the model score distance.
#
# source://rchardet//lib/rchardet/hebrewprober.rb#145
CharDet::MIN_MODEL_DISTANCE = T.let(T.unsafe(nil), Float)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#307
CharDet::MacCyrillicModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/mbcharsetprober.rb#32
class CharDet::MultiByteCharSetProber < ::CharDet::CharSetProber
  # @return [MultiByteCharSetProber] a new instance of MultiByteCharSetProber
  #
  # source://rchardet//lib/rchardet/mbcharsetprober.rb#33
  def initialize; end

  # source://rchardet//lib/rchardet/mbcharsetprober.rb#54
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/mbcharsetprober.rb#51
  def get_charset_name; end

  # source://rchardet//lib/rchardet/mbcharsetprober.rb#85
  def get_confidence; end

  # source://rchardet//lib/rchardet/mbcharsetprober.rb#40
  def reset; end
end

# source://rchardet//lib/rchardet/sbcharsetprober.rb#34
CharDet::NEGATIVE_SHORTCUT_THRESHOLD = T.let(T.unsafe(nil), Float)

# source://rchardet//lib/rchardet/hebrewprober.rb#129
CharDet::NORMAL_KAF = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#131
CharDet::NORMAL_MEM = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#133
CharDet::NORMAL_NUN = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#135
CharDet::NORMAL_PE = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#137
CharDet::NORMAL_TSADI = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/sbcharsetprober.rb#36
CharDet::NUMBER_OF_SEQ_CAT = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/jpcntx.rb#30
CharDet::NUM_OF_CATEGORY = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/utf8prober.rb#30
CharDet::ONE_CHAR_PROB = T.let(T.unsafe(nil), Float)

# other
#
# source://rchardet//lib/rchardet/latin1prober.rb#34
CharDet::OTH = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/sbcharsetprober.rb#37
CharDet::POSITIVE_CAT = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/sbcharsetprober.rb#33
CharDet::POSITIVE_SHORTCUT_THRESHOLD = T.let(T.unsafe(nil), Float)

# Model Table:
# total sequences: 100%
# first 512 sequences: 97.6601%
# first 1024 sequences: 2.3389%
# rest  sequences:      0.1237%
# negative sequences:   0.0009%
#
# source://rchardet//lib/rchardet/langcyrillicmodel.rb#152
CharDet::RussianLangModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/sbcharsetprober.rb#31
CharDet::SAMPLE_SIZE = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/sbcsgroupprober.rb#31
class CharDet::SBCSGroupProber < ::CharDet::CharSetGroupProber
  # @return [SBCSGroupProber] a new instance of SBCSGroupProber
  #
  # source://rchardet//lib/rchardet/sbcsgroupprober.rb#32
  def initialize; end
end

# source://rchardet//lib/rchardet/sbcharsetprober.rb#32
CharDet::SB_ENOUGH_REL_THRESHOLD = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/constants.rb#41
CharDet::SHORTCUT_THRESHOLD = T.let(T.unsafe(nil), Float)

# source://rchardet//lib/rchardet/mbcssm.rb#347
CharDet::SJISCharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/jpcntx.rb#183
class CharDet::SJISContextAnalysis < ::CharDet::JapaneseContextAnalysis
  # source://rchardet//lib/rchardet/jpcntx.rb#184
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/chardistribution.rb#200
class CharDet::SJISDistributionAnalysis < ::CharDet::CharDistributionAnalysis
  # @return [SJISDistributionAnalysis] a new instance of SJISDistributionAnalysis
  #
  # source://rchardet//lib/rchardet/chardistribution.rb#201
  def initialize; end

  # source://rchardet//lib/rchardet/chardistribution.rb#208
  def get_order(aStr); end
end

# source://rchardet//lib/rchardet/sjisprober.rb#30
class CharDet::SJISProber < ::CharDet::MultiByteCharSetProber
  # @return [SJISProber] a new instance of SJISProber
  #
  # source://rchardet//lib/rchardet/sjisprober.rb#31
  def initialize; end

  # source://rchardet//lib/rchardet/sjisprober.rb#48
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/sjisprober.rb#44
  def get_charset_name; end

  # source://rchardet//lib/rchardet/sjisprober.rb#83
  def get_confidence; end

  # source://rchardet//lib/rchardet/sjisprober.rb#39
  def reset; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#349
CharDet::SJISSMModel = T.let(T.unsafe(nil), Hash)

# Shift_JIS
#
# source://rchardet//lib/rchardet/mbcssm.rb#304
CharDet::SJIS_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#341
CharDet::SJIS_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/chardistribution.rb#32
CharDet::SURE_NO = T.let(T.unsafe(nil), Float)

# source://rchardet//lib/rchardet/chardistribution.rb#31
CharDet::SURE_YES = T.let(T.unsafe(nil), Float)

# source://rchardet//lib/rchardet/sbcharsetprober.rb#35
CharDet::SYMBOL_CAT_ORDER = T.let(T.unsafe(nil), Integer)

# NEGATIVE_CAT = 0
#
# source://rchardet//lib/rchardet/sbcharsetprober.rb#40
class CharDet::SingleByteCharSetProber < ::CharDet::CharSetProber
  # @return [SingleByteCharSetProber] a new instance of SingleByteCharSetProber
  #
  # source://rchardet//lib/rchardet/sbcharsetprober.rb#41
  def initialize(model, reversed = T.unsafe(nil), nameProber = T.unsafe(nil)); end

  # source://rchardet//lib/rchardet/sbcharsetprober.rb#66
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/sbcharsetprober.rb#58
  def get_charset_name; end

  # source://rchardet//lib/rchardet/sbcharsetprober.rb#110
  def get_confidence; end

  # source://rchardet//lib/rchardet/sbcharsetprober.rb#49
  def reset; end
end

# Character Mapping Table:
#
# source://rchardet//lib/rchardet/langthaimodel.rb#38
CharDet::TIS620CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langthaimodel.rb#194
CharDet::TIS620ThaiModel = T.let(T.unsafe(nil), Hash)

# Model Table:
# total sequences: 100%
# first 512 sequences: 92.6386%
# first 1024 sequences:7.3177%
# rest  sequences:     1.0230%
# negative sequences:  0.0436%
#
# source://rchardet//lib/rchardet/langthaimodel.rb#63
CharDet::ThaiLangModel = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#403
CharDet::UCS2BECharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#405
CharDet::UCS2BESMModel = T.let(T.unsafe(nil), Hash)

# UCS2-BE
#
# source://rchardet//lib/rchardet/mbcssm.rb#358
CharDet::UCS2BE_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#393
CharDet::UCS2BE_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#459
CharDet::UCS2LECharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#461
CharDet::UCS2LESMModel = T.let(T.unsafe(nil), Hash)

# UCS2-LE
#
# source://rchardet//lib/rchardet/mbcssm.rb#414
CharDet::UCS2LE_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#449
CharDet::UCS2LE_st = T.let(T.unsafe(nil), Array)

# undefined
#
# source://rchardet//lib/rchardet/latin1prober.rb#33
CharDet::UDF = T.let(T.unsafe(nil), Integer)

# source://rchardet//lib/rchardet/mbcssm.rb#534
CharDet::UTF8CharLenTable = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/utf8prober.rb#32
class CharDet::UTF8Prober < ::CharDet::CharSetProber
  # @return [UTF8Prober] a new instance of UTF8Prober
  #
  # source://rchardet//lib/rchardet/utf8prober.rb#33
  def initialize; end

  # source://rchardet//lib/rchardet/utf8prober.rb#49
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/utf8prober.rb#45
  def get_charset_name; end

  # source://rchardet//lib/rchardet/utf8prober.rb#75
  def get_confidence; end

  # source://rchardet//lib/rchardet/utf8prober.rb#39
  def reset; end
end

# source://rchardet//lib/rchardet/mbcssm.rb#536
CharDet::UTF8SMModel = T.let(T.unsafe(nil), Hash)

# UTF-8
#
# source://rchardet//lib/rchardet/mbcssm.rb#470
CharDet::UTF8_cls = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/mbcssm.rb#505
CharDet::UTF8_st = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/universaldetector.rb#38
class CharDet::UniversalDetector
  # @return [UniversalDetector] a new instance of UniversalDetector
  #
  # source://rchardet//lib/rchardet/universaldetector.rb#41
  def initialize; end

  # source://rchardet//lib/rchardet/universaldetector.rb#146
  def close; end

  # Returns the value of attribute done.
  #
  # source://rchardet//lib/rchardet/universaldetector.rb#39
  def done; end

  # source://rchardet//lib/rchardet/universaldetector.rb#64
  def feed(aBuf); end

  # source://rchardet//lib/rchardet/universaldetector.rb#49
  def reset; end

  # Returns the value of attribute result.
  #
  # source://rchardet//lib/rchardet/universaldetector.rb#39
  def result; end
end

# source://rchardet//lib/rchardet/version.rb#2
CharDet::VERSION = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/hebrewprober.rb#147
CharDet::VISUAL_HEBREW_NAME = T.let(T.unsafe(nil), String)

# source://rchardet//lib/rchardet/langhungarianmodel.rb#55
CharDet::Win1250HungarianCharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langhungarianmodel.rb#219
CharDet::Win1250HungarianModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langbulgarianmodel.rb#222
CharDet::Win1251BulgarianModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langcyrillicmodel.rb#291
CharDet::Win1251CyrillicModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langgreekmodel.rb#220
CharDet::Win1253GreekModel = T.let(T.unsafe(nil), Hash)

# source://rchardet//lib/rchardet/langgreekmodel.rb#56
CharDet::Win1253_CharToOrderMap = T.let(T.unsafe(nil), Array)

# source://rchardet//lib/rchardet/langhebrewmodel.rb#195
CharDet::Win1255HebrewModel = T.let(T.unsafe(nil), Hash)

# Windows-1255 language model
# Character Mapping Table:
#
# source://rchardet//lib/rchardet/langhebrewmodel.rb#39
CharDet::Win1255_CharToOrderMap = T.let(T.unsafe(nil), Array)
