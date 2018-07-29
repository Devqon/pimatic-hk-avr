module.exports = {
  title: "pimatic-hk-avr device config schemas"
  hkAvrPresenceSensor: {
    title: "Hk AVR Power Switch"
    description: "Hk AVR Power Switch"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel", "xAttributeOptions"]
    properties:
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the presence state of the
          AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
      volumeDecibel:
        description: """
          If true, the volume is presented in dB, otherwise relative level between 00
          and 99 is displayed
        """
        type: "boolean"
        default: false
  },
  hkAvrMasterVolume: {
    title: "Hk AVR Master Volume"
    description: "Hk AVR Master Volume"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel", "xAttributeOptions"]
    properties:
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the volume state of the
          AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
      volumeDecibel:
        description: """
          If true, the volume is presented in dB, otherwise relative level between 00
          and 99 is displayed
        """
        type: "boolean"
        default: false
      volumeLimit:
        description: """
          If greater than 0, enforce a volume limiter for the maximum volume level
        """
        type: "number"
        default: 0
      maxAbsoluteVolume:
        description: """
          Maximum absolute volume which can be set. Some receivers already stop at a
          lower value than 99
        """
        type: "number"
        default: 99
  },
  hkAvrZoneVolume: {
    title: "Hk AVR Zone Volume"
    description: "Hk AVR Zone Volume"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel", "xAttributeOptions"]
    properties:
      zone:
        description: """
          The zone for which volume shall be controlled. If set to MAIN it is
          equivalent to master volume
        """
        enum: ["MAIN", "ZONE2", "ZONE3"]
        default: "MAIN"
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the zone volume state
          of the AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
      volumeDecibel:
        description: """
          If true, the volume is presented in dB, otherwise relative level
          between 00 and 99 is displayed
        """
        type: "boolean"
        default: false
      volumeLimit:
        description: """
          If greater than 0, enforce a volume limiter for the maximum volume level
        """
        type: "number"
        default: 0
      maxAbsoluteVolume:
        description: """
          Maximum absolute volume which can be set. Some receivers already stop
          at a lower value than 99
        """
        type: "number"
        default: 99
  },
  hkAvrPowerSwitch: {
    title: "Hk AVR Power Switch"
    description: "Hk AVR Power Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the power state
          of the AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
  },
  hkAvrZoneSwitch: {
    title: "Hk AVR Zone Switch"
    description: "Hk AVR Zone Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      zone:
        description: "The zone to be controlled"
        enum: ["MAIN", "ZONE2", "ZONE3"]
        default: "MAIN"
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the zone switch
          state of the AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
  },
  hkAvrMuteSwitch: {
    title: "Hk AVR Mute Switch"
    description: "Hk AVR Mute Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      zone:
        description: "The zone to be controlled"
        enum: ["MAIN", "ZONE2", "ZONE3"]
        default: "MAIN"
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the mute
          state of the AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
  },
  hkAvrInputSelector: {
    title: "Hk AVR Input Selector"
    description: "Hk AVR Input Selector"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      zone:
        description: "The zone to be controlled"
        enum: ["MAIN", "ZONE2", "ZONE3"]
        default: "MAIN"
      interval:
        description: """
          The time interval in seconds (minimum 2) at which the selector
          state of the AVR will be read
        """
        type: "number"
        default: 60
        minimum: 2
      buttons:
        description: "The inputs to select from"
        type: "array"
        default: [
          {
            id: "TUNER"
          }
          {
            id: "DVD"
          }
          {
            id: "TV"
          }
          {
            id: "MPLAY"
          }
        ]
        format: "table"
        items:
          type: "object"
          properties:
            id:
              enum: [
                "CD", "TUNER", "DVD", "BD", "TV", "SAT/CBL", "MPLAY", "GAME", "HDRADIO", "NET",
                "PANDORA", "SIRIUSXM", "SPOTIFY", "LASTFM", "FLICKR", "IRADIO", "SERVER",
                "FAVORITES", "AUX1", "AUX2", "AUX3", "AUX4", "AUX5", "AUX6", "AUX7", "BT",
                "USB", "USB/IPOD", "IPD", "IRP", "FVP",
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