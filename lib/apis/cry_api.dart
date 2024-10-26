// apis/cry_api.dart
import 'package:babystory/models/cry.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/enum/cry_state.dart';
import 'package:babystory/enum/cry_intensity.dart';

class CryApi {
  final HttpUtils httpUtils = HttpUtils();
  final String jwt;

  CryApi({required this.jwt});

  // Create a new cry
  Future<Cry?> createCry({
    required Cry cry,
  }) async {
    try {
      final res = await httpUtils.post(
        url: '/cry/create',
        headers: {'Authorization': 'Bearer $jwt'},
        body: {
          'pet_id': cry.petId,
          'time': cry.time.toIso8601String(),
          'state': cryStateEnToKr[cry.state],
          'audioId': cry.audioId,
          'predictMap': cry.predictMap,
          'intensity': cryIntensityEnToKr[cry.intensity],
          'duration': cry.duration,
        },
      );
      if (res == null || res['cry'] == null) {
        return null;
      }
      return Cry.fromJson(res['cry']);
    } catch (e) {
      return null;
    }
  }

  // Get a cry by ID
  Future<Cry?> getCry({
    required int cryId,
  }) async {
    try {
      final res = await httpUtils.get(
        url: '/cry/cry/$cryId',
        headers: {'Authorization': 'Bearer $jwt'},
      );
      if (res == null || res['cry'] == null) {
        return null;
      }
      return Cry.fromJson(res['cry']);
    } catch (e) {
      return null;
    }
  }

  // Get all cries for a pet
  Future<List<Cry>?> getPetCries({
    required int petId,
  }) async {
    try {
      final res = await httpUtils.get(
        url: '/cry/pet/$petId',
        headers: {'Authorization': 'Bearer $jwt'},
      );
      if (res == null || res['cries'] == null) {
        return null;
      }
      final criesJsonList = res['cries'] as List<dynamic>;
      List<Cry> cries =
          criesJsonList.map((cryJson) => Cry.fromJson(cryJson)).toList();
      return cries;
    } catch (e) {
      return null;
    }
  }

  // Update a cry
  Future<Cry?> updateCry({
    required int cryId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      // Map<String, dynamic> body = {};
      // if (time != null) body['time'] = time.toIso8601String();
      // if (state != null) body['state'] = cryStateEnToKr[state];
      // if (audioId != null) body['audioId'] = audioId;
      // if (predictMap != null) body['predictMap'] = predictMap;
      // if (intensity != null) body['intensity'] = cryIntensityEnToKr[intensity];
      // if (duration != null) body['duration'] = duration;
      final res = await httpUtils.put(
        url: '/cry/$cryId',
        headers: {'Authorization': 'Bearer $jwt'},
        body: updateData,
      );
      if (res == null || res['cry'] == null) {
        return null;
      }
      return Cry.fromJson(res['cry']);
    } catch (e) {
      return null;
    }
  }

  // Delete a cry
  Future<bool> deleteCry({
    required int cryId,
  }) async {
    try {
      final res = await httpUtils.delete(
        url: '/cry/$cryId',
        headers: {'Authorization': 'Bearer $jwt'},
      );
      if (res == null) {
        return false;
      }
      return res['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Get cries with a specific state
  Future<List<Cry>?> getCriesWithState({
    required int petId,
    required String queryState,
  }) async {
    try {
      final res = await httpUtils.get(
        url: '/cry/search/state',
        headers: {'Authorization': 'Bearer $jwt'},
        querys: {
          'pet_id': petId.toString(),
          'query_state': cryStateEnToKr[queryState] ?? 'unknown',
        },
      );
      if (res == null || res['cries'] == null) {
        return null;
      }
      final criesJsonList = res['cries'] as List<dynamic>;
      List<Cry> cries =
          criesJsonList.map((cryJson) => Cry.fromJson(cryJson)).toList();
      return cries;
    } catch (e) {
      return null;
    }
  }

  // Get cries between two times
  Future<List<Cry>> getCriesBetweenTime({
    required int petId,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      final res = await httpUtils.get(
        url: '/cry/search/time',
        headers: {'Authorization': 'Bearer $jwt'},
        querys: {
          'pet_id': petId.toString(),
          'start_time': startTime == null
              ? DateTime.now()
                  .subtract(const Duration(days: 7))
                  .toIso8601String()
              : startTime.toIso8601String(),
          'end_time': endTime == null
              ? DateTime.now().toIso8601String()
              : endTime.toIso8601String(),
        },
      );
      if (res == null || res['cries'] == null) {
        return [];
      }
      final criesJsonList = res['cries'] as List<dynamic>;
      if (criesJsonList.isEmpty) return [];
      print("cryJson: ${criesJsonList[criesJsonList.length - 1]}");
      List<Cry> cries =
          criesJsonList.map((cryJson) => Cry.fromJson(cryJson)).toList();
      return cries;
    } catch (e) {
      return [];
    }
  }
}
