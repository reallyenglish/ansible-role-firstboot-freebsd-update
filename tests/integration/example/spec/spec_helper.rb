require "infrataster/rspec"
require "English"
require "pathname"

ENV["VAGRANT_CWD"] = File.dirname(__FILE__)
ENV["LANG"] = "C"

if ENV["JENKINS_HOME"]
  # XXX inject vagrant `bin` path to ENV["PATH"]
  # https://github.com/reallyenglish/packer-templates/pull/48
  vagrant_path = ""
  Bundler.with_clean_env do
    gem_which_vagrant = `gem which vagrant 2>/dev/null`.chomp
    if gem_which_vagrant != ""
      vagrant_path = Pathname
                     .new(gem_which_vagrant)
                     .parent
                     .parent + "bin"
    end
  end
  ENV["PATH"] = "#{vagrant_path}:#{ENV['PATH']}"
end

def exec_and_abort_if_fail(cmd)
  status = system cmd
  $stderr.puts "`#{cmd}` failed." unless $CHILD_STATUS.exitstatus.zero?
  abort unless $CHILD_STATUS.exitstatus.zero?
  status
end

def vagrant(args)
  Bundler.with_clean_env do
    exec_and_abort_if_fail "vagrant #{args}"
  end
end

Infrataster::Server.define(
  :server1,
  "192.168.21.200",
  vagrant: true
)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
