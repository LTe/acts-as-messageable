# typed: ignore
require 'sorbet-coerce'
require 'sorbet-runtime'

describe TypeCoerce do
  context 'when given T::Struct' do
    class ParamInfo < T::Struct
      const :name, String
      const :lvl, T.nilable(Integer)
      const :skill_ids, T::Array[Integer]
    end

    class ParamInfo2 < T::Struct
      const :a, Integer
      const :b, Integer
      const :notes, T::Array[String], default: []
    end

    class Param < T::Struct
      const :id, Integer
      const :role, String, default: 'wizard'
      const :price, BigDecimal
      const :info, ParamInfo
      const :opt, T.nilable(ParamInfo2)
    end

    class DefaultParams < T::Struct
      const :a, Integer, default: 1
    end

    class HashParams < T::Struct
      const :myhash, T::Hash[String, Integer]
    end

    class HashParamsWithDefault < T::Struct
      const :myhash, T::Hash[String, Integer], default: Hash['a' => 1]
    end

    class TestEnum < T::Enum
      enums do
        Test = new
        Other = new
      end
    end

    class WithEnum < T::Struct
      const :myenum, TestEnum
    end

    class WithNilableString < T::Struct
      const :myvalue, T.nilable(String)
    end

    class WithNilableInteger < T::Struct
      const :myvalue, T.nilable(Integer)
    end

    class CustomType
      attr_reader :a

      def initialize(a)
        @a = a
      end
    end

    class CustomType2
      def self.new(a); 1; end
    end

    class UnsupportedCustomType
      # Does not respond to new
    end

    class WithSupportedUnion < T::Struct
      const :nilable, T.nilable(String)
      const :nilable_boolean, T.nilable(T::Boolean)
    end

    class WithUnsupportedUnion < T::Struct
      const :union, T.any(String, Integer)
    end

    class WithFixedArray < T::Struct
      const :arr, [Integer, String, Integer]
    end

    class CustomString < String
    end

    let!(:param) {
      TypeCoerce[Param].new.from({
        id: 1,
        price: BigDecimal('98.76'),
        info: {
          name: 'mango',
          lvl: 100,
          skill_ids: ['123', '456'],
        },
        opt: {
          a: 1,
          b: 2,
        },
        extra_attr: 'does not matter',
      })
    }

    let!(:param2) {
      TypeCoerce[Param].new.from({
        id: '2',
        price: '98.76',
        info: {
          name: 'honeydew',
          lvl: '5',
          skill_ids: [],
        },
        opt: {
          a: '1',
          b: '2',
          notes: [],
        },
      })
    }

    it 'reveals the right type' do
      T.assert_type!(param, Param)
      T.assert_type!(param.id, Integer)
      T.assert_type!(param.price, BigDecimal)
      T.assert_type!(param.info, ParamInfo)
      T.assert_type!(param.info.name,String)
      T.assert_type!(param.info.lvl, Integer)
      T.assert_type!(param.opt, T.nilable(ParamInfo2))
    end

    it 'coerces correctly' do
      expect(param.id).to eql 1
      expect(param.role).to eql 'wizard'
      expect(param.price).to eql BigDecimal('98.76')
      expect(param.info.lvl).to eql 100
      expect(param.info.name).to eql 'mango'
      expect(param.info.skill_ids).to eql [123, 456]
      expect(param.opt.notes).to eql []
      expect(TypeCoerce[Param].new.from(param)).to eq(param)

      expect(param2.id).to eql 2
      expect(param2.price).to eql BigDecimal('98.76')
      expect(param2.info.name).to eql 'honeydew'
      expect(param2.info.lvl).to eql 5
      expect(param2.info.skill_ids).to eql []
      expect(param2.opt.a).to eql 1
      expect(param2.opt.b).to eql 2
      expect(param2.opt.notes).to eql []

      expect {
        TypeCoerce[Param].new.from({
          id: 3,
          info: {
            # missing required name
            lvl: 2,
          },
        })
      }.to raise_error(ArgumentError)

      expect(TypeCoerce[DefaultParams].new.from(nil).a).to be 1
      expect(TypeCoerce[DefaultParams].new.from('').a).to be 1
    end
  end

  context 'when the given T::Struct is invalid' do
    class Param2 < T::Struct
      const :id, Integer
      const :param, Param
    end

    it 'raises an error' do
      expect {
        TypeCoerce[Param2].new.from({id: 1, info: {}})
      }.to raise_error(ArgumentError)
    end
  end

  context 'when given primitive types' do
    it 'reveals the right type' do
      T.assert_type!(TypeCoerce[Integer].new.from(1), Integer)
      T.assert_type!(TypeCoerce[Integer].new.from('1.0'), Integer)
      T.assert_type!(TypeCoerce[T.nilable(Integer)].new.from(nil), T.nilable(Integer))
    end

    it 'coreces correctly' do
      expect{TypeCoerce[Integer].new.from(nil)}.to raise_error(TypeError)
      expect(TypeCoerce[T.nilable(Integer)].new.from(nil) || 1).to eql 1
      expect(TypeCoerce[Integer].new.from(2)).to eql 2
      expect(TypeCoerce[Integer].new.from('1.0')).to eql 1

      expect{TypeCoerce[T.nilable(Integer)].new.from('invalid integer string')}.to raise_error(TypeCoerce::CoercionError)
      expect(TypeCoerce[Float].new.from('1.0')).to eql 1.0

      expect(TypeCoerce[T::Boolean].new.from('false')).to be false
      expect(TypeCoerce[T::Boolean].new.from('true')).to be true

      expect(TypeCoerce[T.nilable(Integer)].new.from('')).to be nil
      expect{TypeCoerce[T.nilable(Integer)].new.from([])}.to raise_error(TypeCoerce::CoercionError)
      expect(TypeCoerce[T.nilable(String)].new.from('')).to eql ''
    end
  end

  context 'when given custom types' do
    it 'coerces correctly' do
      obj = TypeCoerce[CustomType].new.from(1)
      T.assert_type!(obj, CustomType)
      expect(obj.a).to be 1
      expect(TypeCoerce[CustomType].new.from(obj)).to be obj

      expect{TypeCoerce[UnsupportedCustomType].new.from(1)}.to raise_error(ArgumentError)
      # CustomType2.new(anything) returns Integer 1; 1.is_a?(CustomType2) == false
      expect{TypeCoerce[CustomType2].new.from(1)}.to raise_error(TypeError)
    end
  end

  context 'when given union types' do
    context 'supported union types' do
      it 'coerces correctly' do
        coerced = TypeCoerce[WithSupportedUnion].new.from({
          nilable: 2,
          nilable_boolean: 'true'
        })
        expect(coerced.nilable).to eq('2')
        expect(coerced.nilable_boolean).to eq(true)
      end
    end

    context 'unsupported union types' do
      it 'keeps the values as-is' do
        coerced = TypeCoerce[WithUnsupportedUnion].new.from({union: 'a'})
        expect(coerced.union).to eq('a')

        coerced = TypeCoerce[WithUnsupportedUnion].new.from({union: 2})
        expect(coerced.union).to eq(2)

        expect do
          TypeCoerce[WithUnsupportedUnion].new.from({union: nil})
        end.to raise_error(TypeError)
      end
    end
  end

  context 'when dealing with arrays' do
    it 'coreces correctly' do
      expect(TypeCoerce[T::Array[Integer]].new.from(nil)).to eql []
      expect(TypeCoerce[T::Array[Integer]].new.from('')).to eql []
      expect{TypeCoerce[T::Array[Integer]].new.from('not an array')}.to raise_error(TypeCoerce::ShapeError)
      expect{TypeCoerce[T::Array[Integer]].new.from('1')}.to raise_error(TypeCoerce::ShapeError)
      expect(TypeCoerce[T::Array[Integer]].new.from(['1', '2', '3'])).to eql [1, 2, 3]
      expect{TypeCoerce[T::Array[Integer]].new.from(['1', 'invalid', '3'])}.to raise_error(TypeCoerce::CoercionError)
      expect{TypeCoerce[T::Array[Integer]].new.from({a: 1})}.to raise_error(TypeCoerce::CoercionError)

      infos = TypeCoerce[T::Array[ParamInfo]].new.from([{name: 'a', skill_ids: []}])
      T.assert_type!(infos, T::Array[ParamInfo])
      expect(infos.first.name).to eql 'a'

      infos = TypeCoerce[T::Array[ParamInfo]].new.from([{name: 'b', skill_ids: []}])
      T.assert_type!(infos, T::Array[ParamInfo])
      expect(infos.first.name).to eql 'b'

      expect {
        TypeCoerce[ParamInfo2].new.from({a: nil, b: nil})
      }.to raise_error(TypeError)
    end
  end

  context 'when dealing with hashes' do
    it 'coreces correctly' do
      expect(TypeCoerce[T::Hash[T.untyped, T.untyped]].new.from(nil)).to eql({})

      expect(TypeCoerce[T::Hash[String, T::Boolean]].new.from({
        a: 'true',
        b: 'false',
      })).to eql({
        'a' => true,
        'b' => false,
      })

      expect(TypeCoerce[HashParams].new.from({
        myhash: {'a' => '1', 'b' => '2'},
      }).myhash).to eql({'a' => 1, 'b' => 2})

      expect(TypeCoerce[HashParamsWithDefault].new.from({}).myhash).to eql({'a' => 1})

      expect {
        TypeCoerce[T::Hash[String, T::Boolean]].new.from({
          a: 'invalid',
          b: 'false',
        })
      }.to raise_error(TypeCoerce::CoercionError)

      expect {
        TypeCoerce[T::Hash[String, Integer]].new.from(1)
      }.to raise_error(TypeCoerce::ShapeError)
    end
  end

  context 'when dealing with sets' do
    it 'coreces correctly' do
      expect(TypeCoerce[T::Set[Integer]].new.from(
        Set.new(['1', '2', '3'])
      )).to eq Set.new([1, 2, 3])

      expect {
        TypeCoerce[T::Set[Integer]].new.from(Set.new(['1', 'invalid', '3']))
      }.to raise_error(TypeCoerce::CoercionError)

      expect {
        TypeCoerce[T::Set[Integer]].new.from(1)
      }.to raise_error(TypeCoerce::ShapeError)
    end
  end

  context 'when given a type alias' do
    MyType = T.type_alias(T::Boolean)

    it 'coerces correctly' do
      expect(TypeCoerce[MyType].new.from('false')).to be false
    end
  end

  context 'when dealing with enums' do
    it 'coerces a serialized enum correctly' do
      coerced = TypeCoerce[WithEnum].new.from({myenum: "test"})
      expect(coerced.myenum).to eq(TestEnum::Test)
    end

    it 'handles a real enum correctly' do
      coerced = TypeCoerce[WithEnum].new.from({myenum: TestEnum::Test})
      expect(coerced.myenum).to eq(TestEnum::Test)
    end

    it 'handles bad enum' do
      expect {
        TypeCoerce[WithEnum].new.from({myenum: "bad_key"})
      }.to raise_error(TypeCoerce::CoercionError)
    end
  end

  it 'works with T.untyped' do
    expect(TypeCoerce[T.untyped].new.from(1)).to eql 1

    obj = CustomType.new(1)
    expect(TypeCoerce[T::Hash[String, T.untyped]].new.from({a: obj})).to eq({'a' => obj})
  end

  it 'works with T::Types::FixedArray' do
    type = T.type_alias { [Integer, String, Integer] }
    coerced = TypeCoerce[type].new.from(['1', 2, '3'])
    expect(coerced).to eql([1, '2', 3])

    coerced = TypeCoerce[WithFixedArray].new.from({ arr: ['1', 2, '3'] })
    expect(coerced.arr).to eql([1, '2', 3])
  end

  context 'when dealing with T.class_of' do
    it 'keeps the value as-is' do
      string_class_type = T.class_of(String)
      expect(TypeCoerce[string_class_type].new.from(String)).to eql(String)
      expect(TypeCoerce[string_class_type].new.from(CustomString)).to eql(CustomString)
      expect do
        TypeCoerce[string_class_type].new.from(Integer)
      end.to raise_error(TypeError)
      expect do
        TypeCoerce[string_class_type].new.from('a')
      end.to raise_error(TypeError)
    end
  end

  context 'when dealing with unknown types' do
    context 'raise_coercion_error is enabled' do
      it 'raises error' do
        expect do
          TypeCoerce['a'].new.from('a', raise_coercion_error: true)
        end.to raise_error(TypeCoerce::CoercionError)
      end
    end
    context 'raise_coercion_error is disabled' do
      it 'keeps the value as-is (and let Sorbet raise error)' do
        expect do
          TypeCoerce['a'].new.from('a', raise_coercion_error: false)
        end.to raise_error(/must be an T::Types::Base/i)
      end
    end
  end

  context 'when dealing with coercing empty strings' do
    context 'when flag is set' do
      it 'coerces empty strings to nil from a simple type' do
        expect(TypeCoerce[T.nilable(String)].new.from('', coerce_empty_to_nil: true)).to be_nil
      end

      it 'coerces empty strings to nil from a struct' do
        coerced = TypeCoerce[WithNilableString].new.from({myvalue: ''}, coerce_empty_to_nil: true)
        expect(coerced.myvalue).to eql(nil)
      end
    end

    context 'when flag is not set' do
      it 'coerces empty strings to nil from a simple type' do
        expect(TypeCoerce[T.nilable(String)].new.from('', coerce_empty_to_nil: false)).to eql('')
      end

      it 'coerces empty strings to nil from a struct' do
        coerced = TypeCoerce[WithNilableString].new.from({myvalue: ''}, coerce_empty_to_nil: false)
        expect(coerced.myvalue).to eql('')
      end
    end
  end
end
