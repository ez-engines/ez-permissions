# frozen_string_literal: true

module Ez
  module Permissions
    class ApplicationMailer < ActionMailer::Base
      default from: 'from@example.com'
      layout 'mailer'
    end
  end
end
