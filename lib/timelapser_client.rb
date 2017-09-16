$:.unshift File.dirname(__FILE__)

require 'timelapser_client/command'
require 'timelapser_client/command/templates'
require 'timelapser_client/settings'
require 'logging'

# responsible for taking pictures and sending to host
module TimelapserClient
  def self.shoot_and_send
    logger = Logging.logger(STDOUT)
    shot = Command.new(:shoot,
                       result_path: Settings.snapshots_path,
                       template: template).run!
    logger.info(shot.inspect)
    res = send(shot[:image]) if shot[:success] == true
    logger.info(res.inspect)
  end

  def self.template
    if Settings.env == 'prod'
      Command::Templates::RaspiStillTemplate
    else
      Command::Templates::ImageSnapTemplate
    end
  end

  def self.send(image)
    Command.new(:send, image: image,
                       camera_id: Settings.camera_id,
                       endpoint: Settings.endpoint,
                       token: Settings.token).run!
  end
end
