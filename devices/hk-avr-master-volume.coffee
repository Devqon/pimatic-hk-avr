module.exports = (env) ->

  commons = require('pimatic-plugin-commons')(env)

  class HkAvrMasterVolume extends env.devices.ButtonsDevice

    # Create a new HkAvrMasterVolume device
    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @_base.info @name
      @debug = @plugin.debug || false
      @_base.info @config.buttons
      @config.buttons = [{ id: 'down', text: 'Down'}, { id: 'up', text: 'Up'}]
      super(@config)

    destroy: () ->
      super()

    buttonPressed: (buttonId) =>
      @emit 'button', buttonId
      if buttonId is "up"
        return @_up()
      else
        return @_down()

    _up: () =>
      return @plugin.api.sendRequest('volume-up')

    _down: () =>
      return @plugin.api.sendRequest('volume-down')