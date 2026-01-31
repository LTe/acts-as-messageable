# typed: strict
class ActiveRecord::Relation
  Elem = type_member { {fixed: T.untyped} }
end

class ActiveRecord::Base
  extend Ancestry::HasAncestry
end
