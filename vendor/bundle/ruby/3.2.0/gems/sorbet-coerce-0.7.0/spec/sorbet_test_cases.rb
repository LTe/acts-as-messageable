# typed: false
require 'sorbet-coerce'

T.assert_type!(TypeCoerce[Integer].new.from('1'), Integer)
T.assert_type!(
  TypeCoerce[T.nilable(Integer)].new.from('invalid', raise_coercion_error: false),
  T.nilable(Integer),
)

TypeCoerce::Configuration.raise_coercion_error = true
coercion_error = nil
begin
  TypeCoerce[T.nilable(Integer)].new.from('invalid')
rescue TypeCoerce::CoercionError => e
  coercion_error = e
end
raise 'no coercion error is raised' unless coercion_error

T.assert_type!(
  TypeCoerce[T.nilable(Integer)].new.from('invalid', raise_coercion_error: false),
  T.nilable(Integer),
)
