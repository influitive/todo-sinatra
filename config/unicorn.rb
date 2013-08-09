worker_processes 3

logger Logger.new('log/unicorn.log')
preload_app true

before_fork do |server, worker|
  # If Active Record is loaded: disconnect/close connections on the master process.
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

# This is how we write the PID files for each worker; so we can have monit know the real PID of each worker.
# Additionally if Active Record is loaded re-establish the connection on each worker.
after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end