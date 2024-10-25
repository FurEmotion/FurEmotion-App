import 'package:babystory/enum/cry_intensity.dart';
import 'package:babystory/enum/cry_state.dart';

class Cry {
  final int id;
  final int petId;
  final DateTime time;
  final CryState state;
  final String audioId;
  final Map<String, double> predictMap;
  final CryIntensity intensity;
  final double duration;

  Cry({
    required this.id,
    required this.petId,
    required this.time,
    required this.state,
    required this.audioId,
    required this.predictMap,
    this.intensity = CryIntensity.medium,
    this.duration = 2.0,
  });

  factory Cry.fromJson(Map<String, dynamic> json) {
    return Cry(
      id: json['id'],
      petId: json['petId'] ?? json['pet_id'],
      time: DateTime.parse(json['time']),
      state: cryStateKrToEn[json['state']] ?? CryState.happy,
      audioId: json['audioId'] ?? json['id'].toString(),
      predictMap: Map<String, double>.from(json['predictMap']),
      intensity: cryIntensityKrToEn[json['intensity']] ?? CryIntensity.medium,
      duration: json['duration'] ?? 2.0,
    );
  }

  void printInfo() {
    print(
        'Cry Info: $id, $petId, $time, $state, $audioId, $predictMap, $intensity, $duration');
  }
}
