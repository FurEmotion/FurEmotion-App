import 'dart:io';

import 'package:babystory/apis/pet_api.dart';
import 'package:babystory/apis/raw.api.dart';
import 'package:babystory/enum/pet_gender.dart';
import 'package:babystory/enum/species.dart';
import 'package:babystory/models/pet.dart';
import 'package:babystory/models/user.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/converter.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_dropdown1.dart';
import 'package:babystory/widgets/input/label_input1.dart';
import 'package:babystory/widgets/input/label_num_input1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPetInfoScreen extends StatefulWidget {
  User user;
  Pet? pet;

  EditPetInfoScreen({super.key, required this.user, this.pet});

  @override
  State<EditPetInfoScreen> createState() => _EditPetInfoScreenState();
}

class _EditPetInfoScreenState extends State<EditPetInfoScreen> {
  late PetApi petApi;
  File? _image;
  final picker = ImagePicker();
  late PetUpdateData petBlueprint;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await addNewPhoto(_image!);
    }
  }

  Future<void> submitProfile() async {
    try {
      setState(() {});
      petBlueprint.printInfo();
      Pet? createPetInput = updatedPetToCreatePetData(petBlueprint);
      if (createPetInput == null) {
        alertMissingValue();
        return;
      }
      if (widget.pet == null) {
        var createdPet = await petApi.createPet(
            userId: widget.user.uid, pet: createPetInput);
        if (createdPet != null && _image != null) {
          await petApi.uploadPetProfileImg(
              jwt: widget.user.jwt!,
              petId: createdPet.id,
              filePath: _image!.path);
          alertSuccess();
        }
      } else {
        await petApi.updatePet(petId: widget.pet!.id, updateData: {});
        if (_image != null) {
          await petApi.uploadPetProfileImg(
              jwt: widget.user.jwt!,
              petId: widget.pet!.id,
              filePath: _image!.path);
          alertSuccess();
        }
      }
    } catch (e) {
      alertFailedUpdateProfile();
    }
  }

  Future<void> addNewPhoto(File imageFile) async {
    try {
      if (widget.pet == null) {
        return;
      }
      Pet? createPetInput = updatedPetToCreatePetData(petBlueprint);
      if (createPetInput == null) {
        alertMissingValue();
        return;
      }
      if (widget.pet != null) {
        await petApi.updatePet(petId: widget.pet!.id, updateData: {});
        await petApi.uploadPetProfileImg(
            jwt: widget.user.jwt!,
            petId: widget.pet!.id,
            filePath: imageFile.path);
      }
    } catch (e) {
      alertFailedUpdateProfile();
    }
  }

  Future<void> removePhoto() async {
    // remove the pet profile image
  }

  void alertFailedUpdateProfile() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "프로필 ${widget.pet == null ? '생성' : '수정'}에 실패하였습니다.",
        content: "잠시 후 다시 시도해주세요.",
      );
    }
  }

  void alertMissingValue() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "필수적인 항목을 입력해주세요.",
        content: "이름, 성별, 나이, 종류는 필수 입력 항목입니다.",
      );
    }
  }

  void alertSuccess() {
    Alert.alert(
        context: context,
        title: widget.pet == null ? "축하드립니다!" : "${widget.pet!.name} 프로필 수정 완료",
        content: "반려동물의 정보를 성공적으로 ${widget.pet == null ? "생성" : "수정"}하였습니다.",
        onAccept: navigate);
    Navigator.pop(context);
  }

  Future<void> navigate() async {
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> updateProfile<T extends Object?>(String key, T value) async {
    switch (key) {
      case 'name':
        petBlueprint.name = value as String;
        break;
      case 'gender':
        petBlueprint.gender = petGenderKrToEn[value as String];
        break;
      case 'age':
        petBlueprint.age = value == null ? 0 : (value as num).toInt();
        break;
      case 'species':
        petBlueprint.species = speciesKrToEn[value as String];
        break;
      case 'subSpecies':
        petBlueprint.subSpecies = value as String;
        break;
      case 'photoId':
        petBlueprint.photoId = value as String;
        break;
      default:
        throw Exception("Unknown key: $key");
    }
  }

  void deletePet() async {
    if (mounted) {
      Alert.confirmAlert(
        context: context,
        title: "정말로 삭제하시겠습니까?",
        content: "이 과정은 되돌릴 수 없습니다.",
        onAccept: () async {
          petApi
              .deletePet(petId: widget.pet!.id)
              .then((value) => Navigator.pop(context));
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    petApi = PetApi(jwt: widget.user.jwt!);
    petBlueprint = widget.pet == null
        ? PetUpdateData()
        : PetUpdateData.fromJson(widget.pet!.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleClosedAppBar(
            title:
                widget.pet == null ? "반려동물 추가" : "${widget.pet!.name} 정보 수정"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider<Object>
                          : NetworkImage(RawApi.getPetProfileLink(
                              widget.pet?.id.toString())),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("프로필 사진 수정",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 2),
                        TextButton(
                          onPressed: widget.pet?.photoId != null
                              ? removePhoto
                              : () => pickImage(),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: Text(
                              widget.pet?.photoId != null ? "사진 삭제" : "사진 추가",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: widget.pet?.photoId != null
                                      ? Colors.red
                                      : Colors.blue)),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 0.7, // 경계선 두께
                      ),
                    ),
                  ),
                  child: const SizedBox(width: double.infinity, height: 20),
                ),
                const SizedBox(height: 12),
                LabelInput1(
                    label: "이름",
                    hint: "이름을 입력해주세요",
                    value: petBlueprint.name ?? '',
                    onFocusOut: (value) => updateProfile('name', value)),
                LabelDropdown1(
                    label: "성별",
                    options: allowedPetGenderKr,
                    value: petGenderEnToKr[petBlueprint.gender] ??
                        allowedPetGenderKr[0],
                    onSelected: (value) => updateProfile('gender', value)),
                LabelNumInput1(
                    label: "나이",
                    hint: "나이를 입력해주세요.",
                    value: petBlueprint.age ?? 0,
                    onFocusOut: (value) => updateProfile("age", value)),
                LabelDropdown1(
                    label: "종류",
                    options: allowedSpeciesKr,
                    value: speciesEnToKr[petBlueprint.species] ??
                        allowedSpeciesKr[0],
                    onSelected: (value) => updateProfile('species', value)),
                LabelInput1(
                    label: "품종",
                    hint: "품종을 입력해주세요",
                    value: petBlueprint.subSpecies ?? "",
                    onFocusOut: (value) => updateProfile('subSpecies', value)),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(173, 95, 63, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        widget.pet == null ? '추가하기' : '수정하기',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                widget.pet == null
                    ? Container()
                    : Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: deletePet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(174, 204, 55, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            child: const Text(
                              '반려동물 삭제하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
