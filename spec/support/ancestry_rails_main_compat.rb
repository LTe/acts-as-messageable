# typed: false
# frozen_string_literal: true

# Rails main removed the private `validation_context=` writer
# (rails/rails@0f9d1270), but ancestry still calls it in
# `sane_ancestor_ids?`. Restore it until ancestry ships a fix.
unless ActiveModel::Validations.method_defined?(:validation_context=) ||
       ActiveModel::Validations.private_method_defined?(:validation_context=)
  module ActiveModel
    module Validations
      def validation_context=(context)
        context_for_validation.context = context
      end
      private :validation_context=
    end
  end
end
