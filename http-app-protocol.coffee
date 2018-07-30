# HttpAppProtocol class
module.exports = (env) ->

  Promise = env.require 'bluebird'
  rest = require('restler-promise')(Promise)
  commons = require('pimatic-plugin-commons')(env)
  http = require 'http'

  class HttpAppProtocol extends require('events').EventEmitter
    constructor: (@config) ->
      @scheduledUpdates = {}
      @host = @config.host
      @port = @config.port || 10025
      @debug = @config.debug || false
      @opts =
        agent: new http.Agent()
      @base = commons.base @, 'HttpAppProtocol'
      @on "newListener", =>
        @base.debug "Status response event listeners: #{1 + @listenerCount 'response'}"

    pause: (ms=50) ->
      @base.debug "Pausing:", ms, "ms"
      Promise.delay ms

    _mapZoneToCommandPrefix: (command) ->
      switch command[...2]
        when 'Z2' then return 'Zone 2'
        else return ''

    _mapZoneToObjectKey: (command) ->
      switch command[...2]
        when 'Z2' then return 'Zone 2'
        else return 'main'

    _triggerResponse: (command, param) ->
      # emulate the regex matcher of telnet transport - should be refactored
      @emit 'response',
        matchedResults: [
          "#{command}#{param}"
          "#{command}",
          "#{param}"
          index: 0
          input: "#{command}#{param}"
        ]
        command: command
        param: param
        message: "#{command}#{param}"

    _createCommand: (command, param="", zone="Main Zone") ->
      xml = """
        <?xml version="1.0" encoding="UTF-8"?>
       <harman>
           <avr>
               <common>
                   <control>
                       <name>""" + command + """</name>
                       <zone>""" + zone + """</zone>
                       <para>""" + param + """</para>
                   </control>
               </common>
           </avr>
       </harman>
      """
      command = """POST AVR HTTP/1.1\r\nHost: :""" + "10025" \
                  + """\r\nUser-Agent: Harman Kardon AVR Remote """\
                  + """Controller /2.0""" \
                  + """\r\nContent-Length: """ + xml.length \
                  + """\r\n\r\n""" + xml
      return command

    sendRequest: (command, param="", immediate=false) ->
      @base.info "send request with #{command} and #{param}"
      @command = @_createCommand(command, param)

      return new Promise (resolve, reject) =>
        if command is "mute-toggle" || param is "?"
          @base.info "doing nothing..."
          resolve()
          return;

        url = "http://#{@host}:#{@port}"
        @base.info "requesting #{url} with command #{command} and param #{param}"
        options = {
          data: @command
          headers: {
            'Content-Type': 'application/xml'
          }
        }
        promise = rest.post url, options

        promise.then =>
          @base.debug "Successfully send hk avr command"
          resolve()
        .catch (errorResult) =>
          reject errorResult.error