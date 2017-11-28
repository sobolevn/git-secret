require 'serverspec'

# :backend can be either :exec or :ssh
# since we are running local we use :exec
set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
  end
end
