# #pimatic-hk-avr plugin config options
module.exports = {
  title: "pimatic-hk-avr plugin config options"
  type: "object"
  properties:
    debug:
      description: "Debug mode. Writes debug messages to the pimatic log, if set to true."
      type: "boolean"
      default: false
    host:
      description: "Hostname or IP address of the AVR"
      type: "string"
    port:
      description: """
        AVR control port (inly required for testing). Defaults to port 10025
      """
      type: "number"
      default: 10025,
      required: false
}