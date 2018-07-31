module.exports = (env) ->

  Promise = env.require 'bluebird'
  rp = require('request-promise')
  commons = require('pimatic-plugin-commons')(env)

  class HkAvrApi
    constructor: (@config) ->
      @_base = commons.base @, "HkAvrApi"
      @host = @config.host
      @port = @config.port

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
      command = """POST AVR HTTP/1.1\r\nHost: :""" + @host \
                  + """\r\nUser-Agent: Harman Kardon AVR Remote """\
                  + """Controller /2.0""" \
                  + """\r\nContent-Length: """ + xml.length \
                  + """\r\n\r\n""" + xml
      return command

    sendRequest: (command, param="", immediate=false) ->
      @_base.debug "send request with #{command} and #{param}"
      xml = @_createCommand(command, param)

      return new Promise (resolve, reject) =>
        url = "http://#{@host}:#{@port}"
        options = {
          method: 'POST'
          uri: url
          body: xml
          headers: {
            'Content-Type': 'application/xml'
          }
        }

        promise = rp(options)

        promise.then =>
          @_base.debug "Successfully send hk avr command"
          resolve()
        .catch (errorResult) =>
          reject errorResult.error

    
