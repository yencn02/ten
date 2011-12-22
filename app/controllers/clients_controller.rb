class ClientsController < ApplicationController
#  layout "temp"
  before_filter :login_required
end
