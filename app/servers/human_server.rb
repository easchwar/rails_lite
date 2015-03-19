require_relative '../controllers/humans_controller'
require_relative '../models/human'



router = Controller::Router.new
router.draw do
  get "/humans", HumansController, :index
  get "/humans/:id", HumansController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
