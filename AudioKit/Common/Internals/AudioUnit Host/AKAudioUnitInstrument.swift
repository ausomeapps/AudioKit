//
//  AKAudioUnitInstrument.swift
//  AudioKit
//
//  Created by Ryan Francesconi, revision history on Github.
//  Copyright © 2017 AudioKit. All rights reserved.
//

/// Wrapper for audio units that accept MIDI (ie. instruments)
open class AKAudioUnitInstrument: AKMIDIInstrument {

    /// Initialize the audio unit instrument
    ///
    /// - parameter audioUnit: AVAudioUnitMIDIInstrument to wrap
    ///
    public init?(audioUnit: AVAudioUnitMIDIInstrument) {
        super.init()
        self.midiInstrument = audioUnit

        AudioKit.engine.attach(audioUnit)

        // assign the output to the mixer
        self.avAudioNode = audioUnit
        self.name = audioUnit.name
    }

    /// Send MIDI Note On information to the audio unit
    ///
    /// - Parameters
    ///   - noteNumber: MIDI note number to play
    ///   - velocity: MIDI velocity to play the note at
    ///   - channel: MIDI channel to play the note on
    ///
    open func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity = 64, channel: MIDIChannel = 0) {
        guard self.midiInstrument != nil else {
            AKLog("no midiInstrument exists")
            return
        }
//        cbytes[0] = 0xB0
//        cbytes[1] = 123
//        cbytes[2] = 0
        //self.midiInstrument!.sendMIDIEvent(0xB0, data1: noteNumber, data2: velocity)
        self.midiInstrument!.startNote(noteNumber, withVelocity: velocity, onChannel: channel)
    }

    /// Send MIDI Note Off information to the audio unit
    ///
    /// - Parameters
    ///   - noteNumber: MIDI note number to stop
    ///   - channel: MIDI channel to stop the note on
    ///
    override open func stop(noteNumber: MIDINoteNumber) {
        stop(noteNumber: noteNumber, channel: 0)
    }
    override open func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        guard self.midiInstrument != nil else {
            AKLog("no midiInstrument exists")
            return
        }
        self.midiInstrument!.stopNote(noteNumber, onChannel: channel)
    }

}
