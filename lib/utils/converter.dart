import 'package:babystory/models/pet.dart';

Pet? updatedPetToCreatePetData(PetUpdateData updatedPet) {
  try {
    return Pet(
      id: updatedPet.id ?? 0,
      name: updatedPet.name!,
      gender: updatedPet.gender!,
      age: updatedPet.age!,
      species: updatedPet.species!,
      subSpecies: updatedPet.subSpecies,
      photoId: updatedPet.photoId,
    );
  } catch (e) {
    print("Error in updatedPetToCreatePetData: $e");
    return null;
  }
}
