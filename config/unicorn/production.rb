worker_processes 2
working_directory '/home/deploy/inseason/current'

listen '/tmp/unicorn-inseason.sock', :backlog => 64
pid '/home/deploy/inseason/current/tmp/pids/unicorn.pid'

stderr_path '/home/deploy/inseason/shared/log/unicorn.stderr.log'
stdout_path '/home/deploy/inseason/shared/log/unicorn.stdout.log'

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{root}/Gemfile"
end

before_fork do |server, worker|
  old_pid ='/home/deploy/inseason/current/tmp/pids/unicorn.pid.oldbin'

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
