require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

namespace 'assets' do
  task 'compile' do
    `lessc less/style.less > public/stylesheets/style.css`
  end
end
