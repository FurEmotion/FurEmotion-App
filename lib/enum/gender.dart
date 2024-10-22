enum Gender {
  male,
  female,
  unknown,
}

const Map<Gender, String> genderEnToKr = {
  Gender.male: '남성',
  Gender.female: '여성',
  Gender.unknown: '비공개',
};

const Map<String, Gender> genderKrToEn = {
  '남성': Gender.male,
  '여성': Gender.female,
  '비공개': Gender.unknown,
};

List<String> allowedGenderEn =
    Gender.values.map((e) => e.toString().split('.').last).toList();
List<String> allowedGenderKr = genderEnToKr.values.toList();
