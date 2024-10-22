import 'package:babystory/enum/species.dart';
import 'package:babystory/services/notification.dart';
import 'package:babystory/services/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class AudioProcessor {
  late RecordService _recordService;
  late NotificationService _notificationService;
  final bool Function() isListening;
  final Species species;

  AudioProcessor({
    required this.isListening,
    required this.species,
  }) {
    _recordService = RecordService(species: species);
    _notificationService = NotificationService();
  }

  Future<void> waitForSoundAndAnalyze({
    required Function() onAnalysisStarted,
    required Function(String) onAnalysisComplete,
  }) async {
    var dir = (await getApplicationDocumentsDirectory()).path;
    var filePath = '$dir/tempRecord.wav';

    bool hasDetected = await _recordService.waitSound(filePath, isListening);

    if (hasDetected && isListening()) {
      _notificationService.showNotification(
          'FurMotion', '반려동물이 울고 있어요! 원인을 분석중입니다...');
      onAnalysisStarted();
      await Future.delayed(const Duration(seconds: 1));
      try {
        onAnalysisComplete(filePath);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
