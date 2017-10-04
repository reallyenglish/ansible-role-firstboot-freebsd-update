require "spec_helper"
require "serverspec"

describe file("/usr/local/etc/rc.d/firstboot_freebsd_update") do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
  its(:content) { should match(/^# Managed by ansible/) }
end

describe file("/etc/rc.conf.d/firstboot_freebsd_update") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "wheel" }
  its(:content) { should match(/^# Managed by ansible/) }
  its(:content) { should match(/^firstboot_freebsd_update_flags="--not-running-from-cron"$/) }
end

describe service("firstboot_freebsd_update") do
  it { should be_enabled }
end
