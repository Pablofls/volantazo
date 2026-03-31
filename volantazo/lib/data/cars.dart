class Car {
  final String id;
  final String name;
  final String category;

  const Car({required this.id, required this.name, required this.category});
}

const List<Car> allCars = [
  Car(id: 'bmw_m6_gt3', name: 'BMW M6 GT3', category: 'GT3'),
  Car(id: 'mercedes_amg_gt3', name: 'Mercedes-AMG GT3', category: 'GT3'),
  Car(id: 'lamborghini_huracan_gt3', name: 'Lamborghini Huracán GT3', category: 'GT3'),
  Car(id: 'ferrari_488_gt3', name: 'Ferrari 488 GT3', category: 'GT3'),
  Car(id: 'porsche_911_gt3_r', name: 'Porsche 911 GT3 R', category: 'GT3'),
  Car(id: 'audi_r8_lms', name: 'Audi R8 LMS', category: 'GT3'),
  Car(id: 'mclaren_650s_gt3', name: 'McLaren 650S GT3', category: 'GT3'),
  Car(id: 'nissan_gtr_gt3', name: 'Nissan GT-R GT3', category: 'GT3'),
  Car(id: 'ferrari_458_gt2', name: 'Ferrari 458 GT2', category: 'GT2/GTE'),
  Car(id: 'bmw_z4_gt3', name: 'BMW Z4 GT3', category: 'GT2/GTE'),
  Car(id: 'corvette_c7r', name: 'Corvette C7.R', category: 'GT2/GTE'),
  Car(id: 'tatuus_fa01', name: 'Tatuus FA01', category: 'Formula'),
  Car(id: 'tatuus_f4', name: 'Tatuus F4', category: 'Formula'),
  Car(id: 'toyota_ts040', name: 'Toyota TS040 Hybrid', category: 'Prototype'),
  Car(id: 'porsche_919', name: 'Porsche 919 Hybrid', category: 'Prototype'),
  Car(id: 'audi_r18', name: 'Audi R18 e-tron Quattro', category: 'Prototype'),
  Car(id: 'ferrari_laferrari', name: 'Ferrari LaFerrari', category: 'Supercar'),
  Car(id: 'ferrari_f40', name: 'Ferrari F40', category: 'Supercar'),
  Car(id: 'ferrari_458', name: 'Ferrari 458 Italia', category: 'Supercar'),
  Car(id: 'lamborghini_aventador', name: 'Lamborghini Aventador SV', category: 'Supercar'),
  Car(id: 'lamborghini_countach', name: 'Lamborghini Countach', category: 'Supercar'),
  Car(id: 'pagani_huayra', name: 'Pagani Huayra', category: 'Supercar'),
  Car(id: 'pagani_zonda_r', name: 'Pagani Zonda R', category: 'Supercar'),
  Car(id: 'mclaren_p1', name: 'McLaren P1', category: 'Supercar'),
  Car(id: 'mclaren_mp4_12c', name: 'McLaren MP4-12C', category: 'Supercar'),
  Car(id: 'lotus_exige_s', name: 'Lotus Exige S', category: 'Sports'),
  Car(id: 'lotus_exige_scura', name: 'Lotus Exige Scura', category: 'Sports'),
  Car(id: 'lotus_evora_gte', name: 'Lotus Evora GTE', category: 'Sports'),
  Car(id: 'lotus_2_eleven', name: 'Lotus 2-Eleven', category: 'Sports'),
  Car(id: 'alfa_romeo_4c', name: 'Alfa Romeo 4C', category: 'Sports'),
  Car(id: 'mazda_mx5', name: 'Mazda MX-5', category: 'Sports'),
  Car(id: 'mazda_mx5_cup', name: 'Mazda MX-5 Cup', category: 'Sports'),
  Car(id: 'fiat_500_abarth', name: 'Fiat 500 Abarth', category: 'Sports'),
  Car(id: 'abarth_595', name: 'Abarth 595 SS', category: 'Sports'),
  Car(id: 'bmw_m3_e30', name: 'BMW M3 E30', category: 'Road'),
  Car(id: 'bmw_m3_e92', name: 'BMW M3 E92', category: 'Road'),
  Car(id: 'bmw_1m', name: 'BMW 1M', category: 'Road'),
  Car(id: 'ford_mustang_2015', name: 'Ford Mustang 2015', category: 'Road'),
  Car(id: 'shelby_cobra', name: 'Shelby Cobra 427 S/C', category: 'Road'),
  Car(id: 'toyota_ae86', name: 'Toyota AE86', category: 'Road'),
  Car(id: 'alfa_romeo_gta', name: 'Alfa Romeo GTA', category: 'Road'),
  Car(id: 'alfa_romeo_155', name: 'Alfa Romeo 155 Ti V6', category: 'Road'),
  Car(id: 'lotus_49', name: 'Lotus 49', category: 'Classic'),
  Car(id: 'lotus_98t', name: 'Lotus 98T', category: 'Classic'),
  Car(id: 'ferrari_312t', name: 'Ferrari 312T', category: 'Classic'),
  Car(id: 'ferrari_312_67', name: 'Ferrari 312/67', category: 'Classic'),
];

Car? getCarById(String id) {
  try {
    return allCars.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}
