require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

namespace 'assets' do
  task 'compile' do
    `lessc assets/less/inseason.less > public/stylesheets/inseason.css`
    `coffee -c -o public/javascripts/ assets/coffee/inseason.coffee `
  end
end
