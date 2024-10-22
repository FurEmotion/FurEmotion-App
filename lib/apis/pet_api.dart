// apis/pet_api.dart
import 'package:furEmotion/enum/pet_gender.dart';
import 'package:furEmotion/enum/species.dart';
import 'package:furEmotion/models/pet.dart';
import 'package:furEmotion/utils/http.dart';

class PetApi {
  final HttpUtils httpUtils = HttpUtils();
  final String jwt;

  PetApi({required this.jwt});

  Future<Pet?> createPet({
    required String userId,
    required Pet pet,
  }) async {
    try {
      final res = await httpUtils.post(url: '/pet/create', headers: {
        'Authorization': 'Bearer $jwt'
      }, body: {
        'user_id': userId,
        'name': pet.name,
        'gender': petGenderEnToKr[pet.gender],
        'age': pet.age,
        'species': speciesEnToKr[pet.species],
        'sub_species': pet.subSpecies
      });
      if (res == null || res['pet'] == null) {
        return null;
      }
      return Pet.fromJson(res['pet']);
    } catch (e) {
      return null;
    }
  }

  // Get pet by ID
  Future<Pet?> getPet({
    required int petId,
  }) async {
    try {
      final res = await httpUtils
          .get(url: '/pet/$petId', headers: {'Authorization': 'Bearer $jwt'});
      if (res == null || res['pet'] == null) {
        return null;
      }
      return Pet.fromJson(res['pet']);
    } catch (e) {
      return null;
    }
  }

  // Get all pets for a user
  Future<List<Pet>?> getUserPets({
    required String userId,
  }) async {
    try {
      final res = await httpUtils.get(
          url: '/pet/user/$userId', headers: {'Authorization': 'Bearer $jwt'});
      if (res == null || res['pets'] == null) {
        return null;
      }
      final petsJsonList = res['pets'] as List<dynamic>;
      List<Pet> pets =
          petsJsonList.map((petJson) => Pet.fromJson(petJson)).toList();
      return pets;
    } catch (e) {
      return null;
    }
  }

  // Update pet
  Future<Pet?> updatePet({
    required int petId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final res = await httpUtils.put(
        url: '/pet/$petId',
        headers: {'Authorization': 'Bearer $jwt'},
        body: updateData,
      );
      if (res == null || res['pet'] == null) {
        return null;
      }
      return Pet.fromJson(res['pet']);
    } catch (e) {
      return null;
    }
  }

  // Delete pet
  Future<bool> deletePet({
    required int petId,
  }) async {
    try {
      final res = await httpUtils.delete(
          url: '/pet/$petId', headers: {'Authorization': 'Bearer $jwt'});
      if (res == null) {
        return false;
      }
      return res['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
