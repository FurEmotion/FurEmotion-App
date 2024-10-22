import 'package:babystory/enum/pet_gender.dart';
import 'package:babystory/enum/species.dart';

class Pet {
  final int id;
  final String name;
  final PetGender gender;
  final int age;
  final Species species;
  final String? subSpecies;
  final String? photoId;

  Pet({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.species,
    this.subSpecies,
    this.photoId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      gender: petGenderKrToEn[json['gender']!] ?? PetGender.spayed,
      age: json['age'],
      species: speciesKrToEn[json['species']] ?? Species.dog,
      subSpecies: json['subSpecies'],
      photoId: json['photoId'],
    );
  }

  factory Pet.fromBlueprint(PetBlueprint blueprint) {
    return Pet(
      id: blueprint.id,
      name: blueprint.name,
      gender: blueprint.gender,
      age: blueprint.age,
      species: blueprint.species,
      subSpecies: blueprint.subSpecies,
      photoId: blueprint.photoId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': petGenderEnToKr[gender],
      'age': age,
      'species': speciesEnToKr[species],
      'subSpecies': subSpecies,
      'photoId': photoId,
    };
  }

  void printInfo() {
    print(
        'Pet Info: $id, $name, $gender, $age, $species, $subSpecies, $photoId');
  }
}

class PetBlueprint {
  int id;
  String name;
  PetGender gender;
  int age;
  Species species;
  String? subSpecies;
  String? photoId;

  PetBlueprint({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.species,
    this.subSpecies,
    this.photoId,
  });
}
