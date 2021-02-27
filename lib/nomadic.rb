module Nomadic
  autoload :CLI, "nomadic/cli"
  autoload :VERSION, "nomadic/version"
  #  autoload :APP, "nomadic/app"
  require 'nomadic/user'
  require 'nomadic/app'
  require 'nomadic/repo'
end
