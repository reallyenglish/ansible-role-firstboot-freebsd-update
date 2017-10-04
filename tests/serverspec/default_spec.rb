require "spec_helper"
require "serverspec"

package = "firstboot-freebsd-update"
service = "firstboot-freebsd-update"
config  = "/etc/firstboot-freebsd-update/firstboot-freebsd-update.conf"
user    = "firstboot-freebsd-update"
group   = "firstboot-freebsd-update"
ports   = [PORTS]
log_dir = "/var/log/firstboot-freebsd-update"
db_dir  = "/var/lib/firstboot-freebsd-update"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/firstboot-freebsd-update.conf"
  db_dir = "/var/db/firstboot-freebsd-update"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("firstboot-freebsd-update") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/firstboot-freebsd-update") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
