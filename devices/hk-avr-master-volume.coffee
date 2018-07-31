module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)

  class HkAvrMasterVolume extends env.devices.Device

    actions:
      up:
        description: "Up"
      down:
        description: "Down"

    # Create a new HkAvrMasterVolume device
    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug || false
      super()

    destroy: () ->
      super()

    up: () =>
      return @plugin.api.sendRequest('volume-up')

    down: () =>
      return @plugin.api.sendRequest('volume-down')