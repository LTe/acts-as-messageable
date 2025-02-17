# typed: strict

module ActiveRecord
  class Relation
    Elem = type_member { { fixed: T.untyped } }
  end
end

module ActiveRecord
  class Base
    include Ancestry::InstanceMethods
  end
end
