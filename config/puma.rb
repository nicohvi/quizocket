workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['MIN_THREADS']  || 10), Integer([ENV['MAX_THREADS'] || 10)

preload_app!

rackup      DefaultRackup
port        ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do

  # Set the number of concurrent connections to the database
  # to the same as max threads.
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] 
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10
    config['pool'] =              ENV['MAX_THREADS'] || 10
    ActiveRecord::Base.establish_connection(config)
  end

end
