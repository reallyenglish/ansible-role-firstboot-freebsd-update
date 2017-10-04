require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provision finishes" do
  describe server(:server1) do
    it "runs firstboot_freebsd_update" do
      r = current_server.ssh_exec("sudo /usr/local/etc/rc.d/firstboot_freebsd_update start")
      expect(r).to match(/freebsd-update: Requesting reboot after installing updates/)
    end
  end
end

context "after reboot" do
  before(:all) do
    vagrant :halt
    vagrant :up
  end

  describe server(:server1) do
    it "is updated" do
      r = current_server.ssh_exec("uname -r")
      expect(r).to match(/\d+.\d+-RELEASE-p\d+/)
    end
  end
end
