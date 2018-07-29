# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "hk avr config options"
  type: "object"
  properties:
    ip:
      description: "The ip address of the avr"
      type: "string"
      default: ""
}