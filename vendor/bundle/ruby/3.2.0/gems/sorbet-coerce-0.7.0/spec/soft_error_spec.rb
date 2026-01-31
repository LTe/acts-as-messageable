# typed: false
require 'sorbet-coerce'
require 'sorbet-runtime'

describe TypeCoerce do
  context 'when type errors are soft errors' do
    class SoftErrorTestEnum < T::Enum
      enums do
        Other = new
      end
    end

    let(:ignore_error) { Proc.new {} }

    before(:each) do
      allow(TypeCoerce::Configuration).to receive(
        :raise_coercion_error,
      ).and_return(false)

      allow(T::Configuration).to receive(
        :inline_type_error_handler,
      ).and_return(ignore_error)

      allow(T::Configuration).to receive(
        :call_validation_error_handler,
      ).and_return(ignore_error)

      allow(T::Configuration).to receive(
        :sig_builder_error_handler,
      ).and_return(ignore_error)
    end

    class ParamsWithSortError < T::Struct
      const :a, Integer
    end

    class CustomTypeRaisesHardError
      def initialize(value)
        raise StandardError.new('value cannot be 1') if value == 1
      end
    end

    class CustomTypeDoesNotRiaseHardError
      def self.new(a); 1; end
    end

    let(:invalid_arg) { 'invalid integer string' }

    it 'overwrites the global config when inline config is set' do
      expect {
        TypeCoerce[Integer].new.from(invalid_arg, raise_coercion_error: true)
      }.to raise_error(TypeCoerce::CoercionError)
    end

    it 'works as expected' do
      expect(TypeCoerce[Integer].new.from(invalid_arg)).to eql(nil)
      expect(TypeCoerce[SoftErrorTestEnum].new.from('bad_key')).to eql(nil)

      expect{TypeCoerce[T::Array[Integer]].new.from(1)}.to raise_error(TypeCoerce::ShapeError)
      expect(TypeCoerce[T::Array[Integer]].new.from({a: 1})).to eql([nil])

      expect {
        TypeCoerce[CustomTypeRaisesHardError].new.from(1)
      }.to raise_error(StandardError)
      expect(TypeCoerce[CustomTypeDoesNotRiaseHardError].new.from(1)).to eql(1)

      sorbet_version = Gem.loaded_specs['sorbet-runtime'].version
      if sorbet_version >= Gem::Version.new('0.4.4948')
        expect(TypeCoerce[ParamsWithSortError].new.from({a: invalid_arg}).a).to eql(nil)
      end
    end
  end
end
