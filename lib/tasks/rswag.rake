# frozen_string_literal: true

namespace :rswag do
  desc 'Verify committed OpenAPI artifact is up to date'
  task :verify do
    sh 'bundle exec rake rswag:specs:swaggerize'
    sh 'git diff --exit-code swagger/v1/swagger.yaml'
  end
end
