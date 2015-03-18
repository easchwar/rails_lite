require_relative '../lib/base/controller_base'

class MyController < Controller::Base
  def go
    session["count"] ||= 0
    session["count"] += 1
    # debugger
    render :counting_show
  end

  def now_flash
    flash.now["errors"] = ['flash#now worked correctly']
    render :flash_show
  end

  def redir_flash
    flash["errors"] = ['redirected flash']
    redirect_to '/count'
  end

  def bad_use_of_flash
    flash["errors"] = ['this should persist for another request']
    render :flash_show
  end
end

router = Controller::Router.new
router.draw do
  get Regexp.new("/count$"), MyController, :go
  get Regexp.new("^/errors$"), MyController, :now_flash
  get Regexp.new("^/error/redirect$"), MyController, :redir_flash
  get Regexp.new("^/error/bad$"), MyController, :bad_use_of_flash
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
