module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)

  # Device class representing the power switch of the Denon AVR
  class HkAvrMuteSwitch extends env.devices.PowerSwitch

    # Create a new DenonAvrMuteSwitch device
    # @param [Object] config    device configuration
    # @param [DenonAvrPlugin] plugin   plugin instance
    # @param [Object] lastState state information stored in database
    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @zoneCmd = 'mute-toggle'
      @lastPowerState=null
      @interval = @_base.normalize @config.interval, 2
      @debug = @plugin.debug || false
      @responseHandler = @_createResponseHandler()
      @plugin.protocolHandler.on 'response', @responseHandler
      super()
      @_state = false

    destroy: () ->
      @_base.cancelUpdate()
      @plugin.protocolHandler.removeListener 'response', @responseHandler
      super()

    _createResponseHandler: () ->
      return (response) =>
        @_base.debug "Response", response.matchedResults

    changeStateTo: (newState) ->
      return new Promise (resolve, reject) =>
        @_base.debug "Calling mute toggle from switch"
        resolve()
        return
        @plugin.protocolHandler.sendRequest(@zoneCmd).then =>
          @_setState newState
          resolve()
        .catch (err) =>
          @_base.rejectWithErrorString reject, err

    getState: () ->
      return Promise.resolve @_state
