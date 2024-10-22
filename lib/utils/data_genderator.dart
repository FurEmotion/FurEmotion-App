import 'package:babystory/enum/cry_intensity.dart';
import 'package:babystory/enum/cry_state.dart';
import 'package:babystory/models/cry.dart';
import 'dart:math';

List<Cry> generateRandomCries(int count,
    {DateTime? startDate, DateTime? endDate, int petId = 1}) {
  // If startDate and endDate are not provided, set them to one month ago until now
  startDate ??= DateTime.now().subtract(const Duration(days: 30));
  endDate ??= DateTime.now();

  final random = Random();
  List<Cry> cries = [];

  for (int i = 0; i < count; i++) {
    int id = i + 1;

    // Generate a random time between startDate and endDate
    int totalSeconds = endDate.difference(startDate).inSeconds;
    int randomSeconds = random.nextInt(totalSeconds);
    DateTime time = startDate.add(Duration(seconds: randomSeconds));

    // Generate random probabilities for each emotion in CryState
    List<String> states =
        CryState.values.map((e) => e.toString().split('.').last).toList();

    Map<String, double> predictMap = {};
    List<double> randomValues =
        List.generate(states.length, (_) => random.nextDouble());
    double sum = randomValues.reduce((a, b) => a + b);
    List<double> probabilities = randomValues.map((e) => e / sum).toList();

    for (int j = 0; j < states.length; j++) {
      predictMap[states[j]] = probabilities[j];
    }

    // Determine the state with the highest probability
    String maxStateString =
        predictMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    CryState state = CryState.values
        .firstWhere((e) => e.toString().split('.').last == maxStateString);

    // Generate random intensity
    CryIntensity intensity =
        CryIntensity.values[random.nextInt(CryIntensity.values.length)];

    // Generate random duration between 1.0 and 5.0 seconds
    double duration = 1.0 + random.nextDouble() * 4.0;

    // Generate audioId
    String audioId = '$id.wav';

    // Create the Cry instance
    var cry = Cry(
      id: id,
      petId: petId,
      time: time,
      state: state,
      audioId: audioId,
      predictMap: predictMap,
      intensity: intensity,
      duration: duration,
    );

    cries.add(cry);
  }

  // Sort the cries by time in descending order (most recent first)
  cries.sort((a, b) => b.time.compareTo(a.time));

  return cries;
}
