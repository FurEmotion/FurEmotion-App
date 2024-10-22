enum CryIntensity {
  low,
  medium,
  high,
}

const Map<CryIntensity, String> cryIntensityEnToKr = {
  CryIntensity.low: '낮음',
  CryIntensity.medium: '중간',
  CryIntensity.high: '높음',
};

const Map<String, CryIntensity> cryIntensityKrToEn = {
  '낮음': CryIntensity.low,
  '중간': CryIntensity.medium,
  '높음': CryIntensity.high,
};

List<String> get allowedCryIntensityEn =>
    CryIntensity.values.map((e) => e.name).toList();
List<String> get allowedCryIntensityKr => cryIntensityEnToKr.values.toList();
