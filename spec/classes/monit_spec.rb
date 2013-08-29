require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'monit' do

  let(:title) { 'monit' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('monit').with_ensure('present') }
    it { should contain_service('monit').with_ensure('running') }
    it { should contain_service('monit').with_enable('true') }
    it { should contain_file('monit.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('monit').with_ensure('1.0.42') }
  end

  describe 'Test installation of Debian init configuration file' do
    let(:facts) do
      { 
        :ipaddress => '10.42.42.42',
        :operatinsystem => 'Debian',
      }
    end
    let(:params) do
      {
        :config_file_init_template => 'monit/config_init-debian.erb',
      }
    end
    let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.

# Defaults for monit initscript.  This file is sourced by
# /bin/sh from /etc/init.d/monit.

# Set START to yes to start the monit
START=yes

"
    end
    it { should contain_file('monit.init').with_ensure('present') }
    it { should contain_file('monit.init').with_content(expected) }
  end

  describe 'Test installation using template with default options' do
    let(:facts) do
      { 
        :ipaddress => '10.42.42.42',
        :operatingsystem => 'Debian',
      }
    end
    let(:params) do
      {
        :template => 'monit/monit.conf.erb',
      }
    end
    let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
set daemon 120
set logfile /var/log/monit.log
set idfile /var/lib/monit/id
set statefile /var/lib/monit/state
set eventqueue
    basedir /var/lib/monit/events
    slots   100

include /etc/monit/conf.d/*

"
    end
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_file('monit.conf').with_content(expected) }
  end

  describe 'Test installation using template with all the options' do
    let(:params) do
      {
        :template => 'monit/monit.conf.erb',
        :plugins_dir => '/my/plugin/dir',
        :id_file => '/my/id/file',
        :state_file => '/my/state/file',
        :events_file => '/my/events/file',
        :events_count => '500',
        :daemon_interval => '200',
        :daemon_start_delay => '300',
        :mmonit_url => 'http://some.url/dir',
        :alert_rcpt => 'some@email.ex',
        :alert_exceptions => ['no_this', 'nor_this'],
        :web_interface_host => 'this.host',
        :web_interface_port => '4000',
        :web_interface_allow => ['localhost','user:password','@group'],
        :mailserver => ['smtp.server.ex','another.smtp 2550']
      }
    end
    let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
set daemon 200
    with start delay 300
set idfile /my/id/file
set statefile /my/state/file
set mailserver smtp.server.ex,another.smtp 2550
set eventqueue
    basedir /my/events/file
    slots   500
set mmonit http://some.url/dir
set alert some@email.ex not on { no_this,nor_this }
set httpd port 4000 and
    use address this.host
    allow localhost
    allow user:password
    allow @group

include /my/plugin/dir/*

"
    end
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_file('monit.conf').with_content(expected) }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:params) { {:monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }
    it { should contain_package('monit').with_ensure('present') }
    it { should contain_service('monit').with_ensure('running') }
    it { should contain_service('monit').with_enable('true') }
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_monitor__process('monit_process').with_enable('true') }
    it { should contain_firewall('monit_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it 'should remove Package[monit]' do should contain_package('monit').with_ensure('absent') end
    it 'should stop Service[monit]' do should contain_service('monit').with_ensure('stopped') end
    it 'should not enable at boot Service[monit]' do should contain_service('monit').with_enable('false') end
    it 'should remove monit configuration file' do should contain_file('monit.conf').with_ensure('absent') end
    it { should contain_monitor__process('monit_process').with_enable('false') }
    it { should contain_firewall('monit_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('monit').with_ensure('present') }
    it 'should stop Service[monit]' do should contain_service('monit').with_ensure('stopped') end
    it 'should not enable at boot Service[monit]' do should contain_service('monit').with_enable('false') end
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_monitor__process('monit_process').with_enable('false') }
    it { should contain_firewall('monit_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) do
      { 
        :disableboot => true,
        :monitor => true,
        :firewall => true,
        :port => '42',
        :protocol => 'tcp'
      }
    end
    it { should contain_package('monit').with_ensure('present') }
    it { should_not contain_service('monit').with_ensure('present') }
    it { should_not contain_service('monit').with_ensure('absent') }
    it 'should not enable at boot Service[monit]' do should contain_service('monit').with_enable('false') end
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_monitor__process('monit_process').with_enable('false') }
    it { should contain_firewall('monit_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - disableboot - Debian' do
    let(:facts) do
      { 
        :ipaddress => '10.42.42.42',
        :operatinsystem => 'Debian',
      }
    end
    let(:params) do
      { 
        :disableboot => true,
        :monitor => true,
        :firewall => true,
        :port => '42',
        :protocol => 'tcp'
      }
    end
    it { should contain_package('monit').with_ensure('present') }
    it { should_not contain_service('monit').with_ensure('present') }
    it { should_not contain_service('monit').with_ensure('absent') }
    it 'should not enable at boot Service[monit]' do should contain_service('monit').with_enable('false') end
    it { should contain_file('monit.conf').with_ensure('present') }
    it { should contain_monitor__process('monit_process').with_enable('false') }
    it { should contain_firewall('monit_tcp_42').with_enable('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "monit/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'monit.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'monit.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/monit/spec"} }
    it { should contain_file('monit.conf').with_source('puppet:///modules/monit/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/monit/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('monit.dir').with_source('puppet:///modules/monit/dir/spec') }
    it { should contain_file('monit.dir').with_purge('true') }
    it { should contain_file('monit.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "monit::spec" } }
    it { should contain_file('monit.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'monit.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('monit').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('monit_process').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }
    it { should contain_firewall('monit_tcp_42').with_tool('iptables') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }
    it { should contain_monitor__process('monit_process').with_tool('puppi') }
    it { should contain_firewall('monit_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('monit').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('monit_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monit_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour module specific vars' do should contain_monitor__process('monit_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :monit_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('monit_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('monit_process').with_enable('true') end
  end

end

