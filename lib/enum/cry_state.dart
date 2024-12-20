import 'package:babystory/enum/cry_state/dog.dart';
import 'package:babystory/enum/cry_state/cat.dart';

enum CryState {
  anger,
  play,
  happy,
  sad,
  hunger,
  lonely,
}

final Map<CryState, String> cryStateEnToKr = {
  CryState.anger: '화남',
  CryState.play: '놀고 싶음',
  CryState.happy: '행복함',
  CryState.sad: '슬픔',
  CryState.hunger: '배고픔',
  CryState.lonely: '외로움',
};

final Map<CryState, String> cryStateEnToEnStr = {
  CryState.anger: 'anger',
  CryState.play: 'play',
  CryState.happy: 'happy',
  CryState.sad: 'sad',
  CryState.hunger: 'hunger',
  CryState.lonely: 'lonely',
};

final Map<String, CryState> cryStateEnStrToEn = {
  'anger': CryState.anger,
  'play': CryState.play,
  'happy': CryState.happy,
  'sad': CryState.sad,
  'hunger': CryState.hunger,
  'lonely': CryState.lonely,
  '화남': CryState.anger,
  '놀고 싶음': CryState.play,
  '행복함': CryState.happy,
  '슬픔': CryState.sad,
  '배고픔': CryState.hunger,
  '외로움': CryState.lonely,
};

final Map<String, CryState> cryStateKrToEn = {
  '화남': CryState.anger,
  '놀고 싶음': CryState.play,
  '행복함': CryState.happy,
  '슬픔': CryState.sad,
  '배고픔': CryState.hunger,
  '외로움': CryState.lonely,
};

final Map<String, String> cryStrStateEnToKr = {
  'anger': '화남',
  'play': '놀고 싶음',
  'happy': '행복함',
  'sad': '슬픔',
  'hunger': '배고픔',
  'lonely': '외로움',
};

List<String> get allowedCryStateEn =>
    CryState.values.map((e) => e.name).toList();
List<String> get allowedCryStateKr => cryStateEnToKr.values.toList();

String? checkRightCryState(String species, String state) {
  if (species == 'dog' && !allowedDogCryStateEn.contains(state)) {
    return "state must be one of \${allowedCryStateEn} or their Korean equivalents \${allowedCryStateKr}";
  }
  if (species == 'cat' && !allowedCatCryStateEn.contains(state)) {
    return "state must be one of \${allowedCatCryStateEn} or their Korean equivalents \${allowedCatCryStateKr}";
  }
  return null;
}
