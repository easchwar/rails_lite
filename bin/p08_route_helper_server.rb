require_relative '../lib/base/controller_base'
require_relative '../lib/helper/route_helper'

class MyController < Controller::Base
  def go
    session["count"] ||= 0
    session["count"] += 1
    # debugger
    render :counting_show
  end

  def single_count
    @num = params[:id]
    render :the_number_one
  end

  def now_flash
    flash.now["errors"] = ['flash#now worked correctly']
    render :flash_show
  end

  def redir_flash
    flash["errors"] = ['redirected flash']
    redirect_to count_url
  end

  def bad_use_of_flash
    flash["errors"] = ['this should persist for another request']
    render :flash_show
  end

  def query_string_count
    id = params[:id]
    redirect_to count_url(id)
  end
end

router = Controller::Router.new
router.draw do
  get "/count", MyController, :go
  get "/errors", MyController, :now_flash
  get "/count/:id", MyController, :single_count
  get "/error/redirect", MyController, :redir_flash
  get "/error/bad", MyController, :bad_use_of_flash
  get "/query", MyController, :query_string_count
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
