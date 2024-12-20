enum Species {
  dog,
  cat,
}

const Map<Species, String> speciesEnToKr = {
  Species.dog: '개',
  Species.cat: '고양이',
};

const Map<String, Species> speciesKrToEn = {
  '개': Species.dog,
  '고양이': Species.cat,
};

const Map<String, String> speciesStrEnToKr = {
  'dog': '개',
  'cat': '고양이',
};

List<String> allowedSpeciesEn =
    Species.values.map((e) => e.toString().split('.').last).toList();
List<String> allowedSpeciesKr = speciesEnToKr.values.toList();
