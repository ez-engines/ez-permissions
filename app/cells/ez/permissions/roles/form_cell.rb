# frozen_string_literal: true

module Ez
  module Permissions
    module Roles
      class FormCell < ApplicationCell
        form

        def form_url
          model.new_record? ? path_for('roles') : path_for("roles/#{model.id}")
        end

        def form_method
          model.new_record? ? :post : :put
        end
      end
    end
  end
end
