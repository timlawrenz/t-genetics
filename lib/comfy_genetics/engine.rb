module ComfyGenetics
  class Engine < ::Rails::Engine
    isolate_namespace ComfyGenetics

    # If you want to automatically load migrations from the engine:
    # config.generators do |g|
    #   g.orm :active_record
    #   g.template_engine :haml # or :erb, :slim, etc.
    #   g.test_framework :rspec
    # end

    # initializer 'comfy_genetics.load_migrations' do |app|
    #   unless app.root.to_s.match root.to_s
    #     config.paths['db/migrate'].expanded.each do |expanded_path|
    #       app.config.paths['db/migrate'] << expanded_path
    #     end
    #   end
    # end
  end
end
