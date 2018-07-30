module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)

  # Device class representing the power switch of the AVR
  class HkAvrPowerSwitch extends env.devices.PowerSwitch

    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @interval = @_base.normalize @config.interval, 2
      @debug = @plugin.debug || false
      @responseHandler = @_createResponseHandler()
      @plugin.protocolHandler.on 'response', @responseHandler
      @_state = false
      super()

    destroy: () ->
      @_base.cancelUpdate()
      @plugin.protocolHandler.removeListener 'response', @responseHandler
      super()

    _createResponseHandler: () ->
      return (response) =>
        @_base.debug "Response", response.matchedResults

    changeStateTo: (newState) ->
      return new Promise (resolve, reject) =>
        @plugin.protocolHandler.sendRequest(if newState then 'power-on' else 'sleep').then =>
          @_setState newState
          resolve()
        .catch (err) =>
          @_base.rejectWithErrorString reject, err

    getState: () ->
      return Promise.resolve @_state
