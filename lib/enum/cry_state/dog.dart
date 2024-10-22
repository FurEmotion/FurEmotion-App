enum DogCryState {
  anger,
  play,
  happy,
  sad,
}

final Map<DogCryState, String> dogCryStateEnToKr = {
  DogCryState.anger: '화남',
  DogCryState.play: '놀고 싶음',
  DogCryState.happy: '행복함',
  DogCryState.sad: '슬픔',
};

final Map<String, DogCryState> dogCryStateKrToEn = {
  '화남': DogCryState.anger,
  '놀고 싶음': DogCryState.play,
  '행복함': DogCryState.happy,
  '슬픔': DogCryState.sad,
};

List<String> get allowedDogCryStateEn =>
    DogCryState.values.map((e) => e.name).toList();
List<String> get allowedDogCryStateKr => dogCryStateEnToKr.values.toList();
