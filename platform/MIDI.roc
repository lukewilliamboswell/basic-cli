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
import InternalMidi

FpsTiming : InternalMidi.FpsTiming
Format : InternalMidi.Format
Timing : InternalMidi.Timing
Header : InternalMidi.Header
MidiMessage : InternalMidi.MidiMessage
Bytes : InternalMidi.Bytes
SmpteTime : InternalMidi.SmpteTime
MaybeU16 : InternalMidi.MaybeU16
MetaMessage : InternalMidi.MetaMessage
TrackEventKindMidi : InternalMidi.TrackEventKindMidi
TrackEventKind : InternalMidi.TrackEventKind
TrackEvent : InternalMidi.TrackEvent
Track : InternalMidi.Track
Smf : InternalMidi.Smf

doThing : Smf -> Task {} Str
doThing = \smf ->
    PlatformTasks.sendMidi smf
