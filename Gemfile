source 'http://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'puppet-lint'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
