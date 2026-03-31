export const tracks = [
  // Italy
  { id: 'monza', name: 'Monza', country: 'Italy', layouts: ['GP', 'Junior'] },
  { id: 'mugello', name: 'Mugello', country: 'Italy' },
  { id: 'imola', name: 'Imola', country: 'Italy' },
  { id: 'vallelunga', name: 'Vallelunga', country: 'Italy', layouts: ['Club', 'Extended'] },
  { id: 'magione', name: 'Magione', country: 'Italy' },
  { id: 'misano', name: 'Misano', country: 'Italy' },
  { id: 'trento_bondone', name: 'Trento-Bondone', country: 'Italy' },

  // Germany
  { id: 'nurburgring_gp', name: 'Nürburgring GP', country: 'Germany' },
  { id: 'nurburgring_nordschleife', name: 'Nürburgring Nordschleife', country: 'Germany' },
  { id: 'nurburgring_tourist', name: 'Nürburgring Tourist', country: 'Germany' },

  // UK
  { id: 'silverstone_gp', name: 'Silverstone GP', country: 'UK' },
  { id: 'silverstone_international', name: 'Silverstone International', country: 'UK' },
  { id: 'silverstone_national', name: 'Silverstone National', country: 'UK' },
  { id: 'brands_hatch_gp', name: 'Brands Hatch GP', country: 'UK' },
  { id: 'brands_hatch_indy', name: 'Brands Hatch Indy', country: 'UK' },
  { id: 'donington_gp', name: 'Donington Park GP', country: 'UK' },
  { id: 'donington_national', name: 'Donington Park National', country: 'UK' },

  // Belgium
  { id: 'spa', name: 'Spa-Francorchamps', country: 'Belgium' },

  // Spain
  { id: 'barcelona_gp', name: 'Barcelona-Catalunya GP', country: 'Spain' },
  { id: 'barcelona_national', name: 'Barcelona-Catalunya National', country: 'Spain' },

  // Austria
  { id: 'red_bull_ring_gp', name: 'Red Bull Ring GP', country: 'Austria' },
  { id: 'red_bull_ring_national', name: 'Red Bull Ring National', country: 'Austria' },

  // Netherlands
  { id: 'zandvoort', name: 'Zandvoort', country: 'Netherlands' },

  // France
  { id: 'paul_ricard', name: 'Paul Ricard', country: 'France' },

  // Fictional
  { id: 'black_cat_county', name: 'Black Cat County', country: 'Fictional' },
  { id: 'drift_track', name: 'Drift Track', country: 'Fictional' },
  { id: 'highlands', name: 'Highlands', country: 'Fictional' },
];

export const cars = [
  // GT3
  { id: 'bmw_m6_gt3', name: 'BMW M6 GT3', category: 'GT3' },
  { id: 'mercedes_amg_gt3', name: 'Mercedes-AMG GT3', category: 'GT3' },
  { id: 'lamborghini_huracan_gt3', name: 'Lamborghini Huracán GT3', category: 'GT3' },
  { id: 'ferrari_488_gt3', name: 'Ferrari 488 GT3', category: 'GT3' },
  { id: 'porsche_911_gt3_r', name: 'Porsche 911 GT3 R', category: 'GT3' },
  { id: 'audi_r8_lms', name: 'Audi R8 LMS', category: 'GT3' },
  { id: 'mclaren_650s_gt3', name: 'McLaren 650S GT3', category: 'GT3' },
  { id: 'nissan_gtr_gt3', name: 'Nissan GT-R GT3', category: 'GT3' },

  // GT2/GTE
  { id: 'ferrari_458_gt2', name: 'Ferrari 458 GT2', category: 'GT2/GTE' },
  { id: 'bmw_z4_gt3', name: 'BMW Z4 GT3', category: 'GT2/GTE' },
  { id: 'corvette_c7r', name: 'Corvette C7.R', category: 'GT2/GTE' },

  // Formula
  { id: 'tatuus_fa01', name: 'Tatuus FA01', category: 'Formula' },
  { id: 'tatuus_f4', name: 'Tatuus F4', category: 'Formula' },

  // Prototype
  { id: 'toyota_ts040', name: 'Toyota TS040 Hybrid', category: 'Prototype' },
  { id: 'porsche_919', name: 'Porsche 919 Hybrid', category: 'Prototype' },
  { id: 'audi_r18', name: 'Audi R18 e-tron Quattro', category: 'Prototype' },

  // Supercar
  { id: 'ferrari_laferrari', name: 'Ferrari LaFerrari', category: 'Supercar' },
  { id: 'ferrari_f40', name: 'Ferrari F40', category: 'Supercar' },
  { id: 'ferrari_458', name: 'Ferrari 458 Italia', category: 'Supercar' },
  { id: 'lamborghini_aventador', name: 'Lamborghini Aventador SV', category: 'Supercar' },
  { id: 'lamborghini_countach', name: 'Lamborghini Countach', category: 'Supercar' },
  { id: 'pagani_huayra', name: 'Pagani Huayra', category: 'Supercar' },
  { id: 'pagani_zonda_r', name: 'Pagani Zonda R', category: 'Supercar' },
  { id: 'mclaren_p1', name: 'McLaren P1', category: 'Supercar' },
  { id: 'mclaren_mp4_12c', name: 'McLaren MP4-12C', category: 'Supercar' },

  // Sports
  { id: 'lotus_exige_s', name: 'Lotus Exige S', category: 'Sports' },
  { id: 'lotus_exige_scura', name: 'Lotus Exige Scura', category: 'Sports' },
  { id: 'lotus_evora_gte', name: 'Lotus Evora GTE', category: 'Sports' },
  { id: 'lotus_2_eleven', name: 'Lotus 2-Eleven', category: 'Sports' },
  { id: 'alfa_romeo_4c', name: 'Alfa Romeo 4C', category: 'Sports' },
  { id: 'mazda_mx5', name: 'Mazda MX-5', category: 'Sports' },
  { id: 'mazda_mx5_cup', name: 'Mazda MX-5 Cup', category: 'Sports' },
  { id: 'fiat_500_abarth', name: 'Fiat 500 Abarth', category: 'Sports' },
  { id: 'abarth_595', name: 'Abarth 595 SS', category: 'Sports' },

  // Road / Muscle
  { id: 'bmw_m3_e30', name: 'BMW M3 E30', category: 'Road' },
  { id: 'bmw_m3_e92', name: 'BMW M3 E92', category: 'Road' },
  { id: 'bmw_1m', name: 'BMW 1M', category: 'Road' },
  { id: 'ford_mustang_2015', name: 'Ford Mustang 2015', category: 'Road' },
  { id: 'shelby_cobra', name: 'Shelby Cobra 427 S/C', category: 'Road' },
  { id: 'toyota_ae86', name: 'Toyota AE86', category: 'Road' },
  { id: 'alfa_romeo_gta', name: 'Alfa Romeo GTA', category: 'Road' },
  { id: 'alfa_romeo_155', name: 'Alfa Romeo 155 Ti V6', category: 'Road' },

  // Classic F1
  { id: 'lotus_49', name: 'Lotus 49', category: 'Classic' },
  { id: 'lotus_98t', name: 'Lotus 98T', category: 'Classic' },
  { id: 'ferrari_312t', name: 'Ferrari 312T', category: 'Classic' },
  { id: 'ferrari_312_67', name: 'Ferrari 312/67', category: 'Classic' },
];

export function getTrackById(id) {
  return tracks.find(t => t.id === id);
}

export function getCarById(id) {
  return cars.find(c => c.id === id);
}
