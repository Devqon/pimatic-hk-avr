module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)

  class HkAvrInputSelector extends env.devices.ButtonsDevice

    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @zoneCmd = 'source-selection'
      @debug = @plugin.debug || false
      for b in @config.buttons
        b.text = b.id unless b.text?

      super(@config)

    destroy: () ->
      super()

    buttonPressed: (buttonId) ->
      for b in @config.buttons
        if b.id is buttonId
          @emit 'button', b.id
          return @plugin.api.sendRequest(@zoneCmd, b.id)

      throw new Error("No button with the id #{buttonId} found")