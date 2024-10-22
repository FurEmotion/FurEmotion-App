enum PetGender {
  male,
  female,
  spayed,
}

const Map<PetGender, String> petGenderEnToKr = {
  PetGender.male: '수컷',
  PetGender.female: '암컷',
  PetGender.spayed: '중성화됨',
};

const Map<String, PetGender> petGenderKrToEn = {
  '수컷': PetGender.male,
  '암컷': PetGender.female,
  '중성화됨': PetGender.spayed,
};

List<String> allowedPetGenderEn =
    PetGender.values.map((e) => e.toString().split('.').last).toList();
List<String> allowedPetGenderKr = petGenderEnToKr.values.toList();
