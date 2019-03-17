# This file is used by Rack-based servers to start the application.

### RAILS
require_relative 'config/environment'
run Rails.application

### SLAVE SERVER
# require_relative 'extra/slave_server/server'
# run SlaveServer.freeze.app