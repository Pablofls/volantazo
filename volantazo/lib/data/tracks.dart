class Track {
  final String id;
  final String name;
  final String country;

  const Track({required this.id, required this.name, required this.country});
}

const List<Track> allTracks = [
  Track(id: 'monza', name: 'Monza', country: 'Italy'),
  Track(id: 'mugello', name: 'Mugello', country: 'Italy'),
  Track(id: 'imola', name: 'Imola', country: 'Italy'),
  Track(id: 'vallelunga', name: 'Vallelunga', country: 'Italy'),
  Track(id: 'magione', name: 'Magione', country: 'Italy'),
  Track(id: 'misano', name: 'Misano', country: 'Italy'),
  Track(id: 'trento_bondone', name: 'Trento-Bondone', country: 'Italy'),
  Track(id: 'nurburgring_gp', name: 'Nürburgring GP', country: 'Germany'),
  Track(id: 'nurburgring_nordschleife', name: 'Nürburgring Nordschleife', country: 'Germany'),
  Track(id: 'nurburgring_tourist', name: 'Nürburgring Tourist', country: 'Germany'),
  Track(id: 'silverstone_gp', name: 'Silverstone GP', country: 'UK'),
  Track(id: 'silverstone_international', name: 'Silverstone International', country: 'UK'),
  Track(id: 'silverstone_national', name: 'Silverstone National', country: 'UK'),
  Track(id: 'brands_hatch_gp', name: 'Brands Hatch GP', country: 'UK'),
  Track(id: 'brands_hatch_indy', name: 'Brands Hatch Indy', country: 'UK'),
  Track(id: 'donington_gp', name: 'Donington Park GP', country: 'UK'),
  Track(id: 'donington_national', name: 'Donington Park National', country: 'UK'),
  Track(id: 'spa', name: 'Spa-Francorchamps', country: 'Belgium'),
  Track(id: 'barcelona_gp', name: 'Barcelona-Catalunya GP', country: 'Spain'),
  Track(id: 'barcelona_national', name: 'Barcelona-Catalunya National', country: 'Spain'),
  Track(id: 'red_bull_ring_gp', name: 'Red Bull Ring GP', country: 'Austria'),
  Track(id: 'red_bull_ring_national', name: 'Red Bull Ring National', country: 'Austria'),
  Track(id: 'zandvoort', name: 'Zandvoort', country: 'Netherlands'),
  Track(id: 'paul_ricard', name: 'Paul Ricard', country: 'France'),
  Track(id: 'black_cat_county', name: 'Black Cat County', country: 'Fictional'),
  Track(id: 'drift_track', name: 'Drift Track', country: 'Fictional'),
  Track(id: 'highlands', name: 'Highlands', country: 'Fictional'),
];

Track? getTrackById(String id) {
  try {
    return allTracks.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
}
