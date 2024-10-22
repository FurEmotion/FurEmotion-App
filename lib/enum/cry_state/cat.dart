enum CatCryState {
  happy,
  hunger,
  lonely,
}

final Map<CatCryState, String> catCryStateEnToKr = {
  CatCryState.happy: '행복함',
  CatCryState.hunger: '배고픔',
  CatCryState.lonely: '외로움',
};

final Map<String, CatCryState> catCryStateKrToEn = {
  '행복함': CatCryState.happy,
  '배고픔': CatCryState.hunger,
  '외로움': CatCryState.lonely,
};

List<String> get allowedCatCryStateEn =>
    CatCryState.values.map((e) => e.name).toList();
List<String> get allowedCatCryStateKr => catCryStateEnToKr.values.toList();
