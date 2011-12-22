class GroupsController < ApplicationController
  layout "temp"
  before_filter :login_required
end
