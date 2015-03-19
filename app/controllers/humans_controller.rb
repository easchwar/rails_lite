require_relative '../../lib/base/controller_base'

class HumansController < Controller::Base
  def index
    @humans = Human.all
    render :index
  end

  def show
    @human = Human.find(params[:id].to_i)
    render :show
  end
end
