module.exports = {
  title: "pimatic-hk-avr device config schemas"
  hkAvrPresenceSensor: {
    title: "Hk AVR Power Switch"
    description: "Hk AVR Power Switch"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel", "xAttributeOptions"]
    properties: []
  },
  hkAvrMasterVolume: {
    title: "Hk AVR Master Volume"
    description: "Hk AVR Master Volume"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel", "xAttributeOptions"]
    properties:
      buttons:
        description: "The Down and Up buttons"
        type: "array"
        default: [
          {
            id: "Down"
          }
          {
            id: "Up"
          }
        ]
        format: "table"
        items:
          type: "object"
          properties:
            id:
              enum: [
                "Down", "Up"
              ]
              description: "The up down buttons"
            text:
              type: "string"
              description: """
                The button text to be displayed. The id will be displayed if not set
              """
              required: false
  },
  hkAvrPowerSwitch: {
    title: "Hk AVR Power Switch"
    description: "Hk AVR Power Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties: []
  },
  hkAvrMuteSwitch: {
    title: "Hk AVR Mute Switch"
    description: "Hk AVR Mute Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      zone:
        description: "The zone to be controlled"
        enum: ["Main Zone", "ZONE2"]
        default: "Main Zone"
  },
  hkAvrInputSelector: {
    title: "Hk AVR Input Selector"
    description: "Hk AVR Input Selector"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      zone:
        description: "The zone to be controlled"
        enum: ["Main Zone", "ZONE2"]
        default: "Main Zone"
      buttons:
        description: "The inputs to select from"
        type: "array"
        default: [
          {
            id: "TV"
          }
          {
            id: "Game"
          }
          {
            id: "Disc"
          }
          {
            id: "STB"
          }
        ]
        format: "table"
        items:
          type: "object"
          properties:
            id:
              enum: [
                "Radio", "Tuner", "TV", "Game", "Disc", "STB"
              ]
              description: "The input ids switchable by the AVR"
            text:
              type: "string"
              description: """
                The button text to be displayed. The id will be displayed if not set
              """
              required: false
            confirm:
              description: "Ask the user to confirm the input select"
              type: "boolean"
              default: false
  }
}