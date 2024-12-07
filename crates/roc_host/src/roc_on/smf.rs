use crate::roc_on::header::Header;
use crate::roc_on::track_event::TrackEvent;

#[derive(Clone)]
#[repr(C)]
pub struct Smf {
    pub tracks: roc_std::RocList<roc_std::RocList<TrackEvent>>,
    pub header: Header,
}

impl std::fmt::Debug for Smf {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut debug_struct = f.debug_struct("Smf");

        debug_struct.field("header", &self.header);

        let track_count = self.tracks.len();
        debug_struct.field("track_count", &track_count);

        debug_struct.finish()
    }
}

impl roc_std::RocRefcounted for Smf {
    fn inc(&mut self) {
        self.tracks.inc();
    }
    fn dec(&mut self) {
        self.tracks.dec();
    }
    fn is_refcounted() -> bool {
        true
    }
}

impl<'a> From<&'a Smf> for midly::Smf<'a> {
    fn from(s: &'a Smf) -> midly::Smf<'a> {
        println!("Converting tracks...");

        let tracks = s
            .tracks
            .as_slice()
            .iter()
            .map(|track| {
                println!("Track {:?}", track);
                track
                    .as_slice()
                    .iter()
                    .map(|track_event| {
                        println!("TrackEvent {:?}", track_event);
                        track_event.into()
                    })
                    .collect()
            })
            .collect();

        midly::Smf {
            tracks,
            header: s.header.into(),
        }
    }
}
