module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)

  # Device class representing the power switch of the AVR
  class HkAvrPowerSwitch extends env.devices.PowerSwitch

    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug || false
      @_state = false
      super()

    destroy: () ->
      super()

    changeStateTo: (newState) ->
      return new Promise (resolve, reject) =>
        @plugin.api.sendRequest(if newState then 'power-on' else 'power-off').then =>
          @_setState newState
          resolve()
        .catch (err) =>
          @_base.rejectWithErrorString reject, err

    getState: () ->
      return Promise.resolve @_state
