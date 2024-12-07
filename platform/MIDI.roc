module [
    FpsTiming,
    Format,
    Timing,
    Header,
    MidiMessage,
    Bytes,
    SmpteTime,
    MaybeU16,
    MetaMessage,
    TrackEventKindMidi,
    TrackEventKind,
    TrackEvent,
    Track,
    Smf,
    doThing,
]

import PlatformTasks
import InternalMIDI

FpsTiming : InternalMIDI.FpsTiming
Format : InternalMIDI.Format
Timing : InternalMIDI.Timing
Header : InternalMIDI.Header
MidiMessage : InternalMIDI.MidiMessage
Bytes : InternalMIDI.Bytes
SmpteTime : InternalMIDI.SmpteTime
MaybeU16 : InternalMIDI.MaybeU16
MetaMessage : InternalMIDI.MetaMessage
TrackEventKindMidi : InternalMIDI.TrackEventKindMidi
TrackEventKind : InternalMIDI.TrackEventKind
TrackEvent : InternalMIDI.TrackEvent
Track : InternalMIDI.Track
Smf : InternalMIDI.Smf

doThing : Smf -> Task {} Str
doThing = \smf ->
    PlatformTasks.sendMidi smf
