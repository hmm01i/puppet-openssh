require 'beaker-rspec'
require 'pry'

hosts.each do |host|
  # Install Puppet
  install_package(host, 'puppet')
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => module_root, :module_name => 'ssh')
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-concat', '--version', '1.2.0'), { :acceptable_exit_codes => [0,1] }
#      binding.pry
    end
  end
end
