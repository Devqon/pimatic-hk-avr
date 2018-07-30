module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  commons = require('pimatic-plugin-commons')(env)

  class HkAvrMasterVolume extends env.devices.DimmerActuator

    # Create a new HkAvrMasterVolume device
    # @param [Object] config    device configuration
    # @param [HkAvrPlugin] plugin   plugin instance
    # @param [Object] lastState state information stored in database
    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @id = @config.id
      @name = @config.name
      @interval = @_base.normalize @config.interval, 2
      @volumeDecibel = false
      @volumeLimit = @_base.normalize @config.volumeLimit, 0, 99
      @maxAbsoluteVolume = @_base.normalize @config.maxAbsoluteVolume, 0, 99
      @debug = @plugin.debug || false
      @responseHandler = @_createResponseHandler()
      @plugin.protocolHandler.on 'response', @responseHandler
      @attributes = _.cloneDeep(@attributes)
      @attributes.volume = {
        description: "Volume"
        type: "number"
        acronym: 'VOL'
      }
      @attributes.volume.unit = 'dB' if @volumeDecibel
      @_dimlevel = 0
      @_state = false
      @_volume = 0
      super()
      process.nextTick () =>
        @_requestUpdate true

    destroy: () ->
      @_base.cancelUpdate()
      @plugin.protocolHandler.removeListener 'response', @responseHandler
      super()

    _requestUpdate: (immediate=false) ->
      @_base.cancelUpdate()
      @_base.debug "Requesting update"

    _createResponseHandler: () ->
      return (response) =>
        @_base.debug "Response", response.matchedResults

    _volumeToDecibel: (volume, zeroDB=80) ->
      return @_volumeToNumber(volume) - zeroDB

    _volumeToNumber: (volume) ->
      if _.isString volume
        decimal = if volume.length is 3 then 0.5 else 0
        return decimal + parseInt volume.substring(0, 2)
      else
        return volume

    _setVolume: (volume) ->
      if @volumeDecibel
        @_base.setAttribute 'volume', @_volumeToDecibel volume
      else
        @_base.setAttribute 'volume', @_volumeToNumber volume

    _levelToVolumeParam: (level) ->
      num = Math.round @maxAbsoluteVolume * level / 100
      return if num < 10 then "0" + num else num + ""

    _volumeParamToLevel: (param) ->
      num = @_volumeToNumber param
      return Math.min 100, Math.round(num * 100 / @maxAbsoluteVolume)

    changeDimlevelTo: (newLevel) ->
      return new Promise (resolve, reject) =>
        action = if newLevel > 0 then "volume-up" else "volume-down"

        @plugin.protocolHandler.sendRequest(action).then =>
          @_setDimlevel newLevel
          @_requestUpdate()
          resolve()
        .catch (err) =>
          @_base.rejectWithErrorString reject, err

    getVolume: () ->
      return new Promise.resolve @_volume