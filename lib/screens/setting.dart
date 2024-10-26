import 'package:babystory/apis/pet_api.dart';
import 'package:babystory/enum/species.dart';
import 'package:babystory/models/pet.dart';
import 'package:babystory/models/user.dart';
import 'package:babystory/providers/user_provider.dart';
import 'package:babystory/screens/edit_pet_info.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final AuthServices _authServices = AuthServices();
  late User user;
  late PetApi petApi;
  late Future<void> petFuture;
  Pet? cat;
  Pet? dog;

  User getUserFromProvider() {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      throw Exception('Parent is null');
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
    user = getUserFromProvider();
    petApi = PetApi(jwt: user.jwt ?? '');
    petFuture = getUserPet();
  }

  Future<void> getUserPet() async {
    var pets = await petApi.getUserPets(userId: user.uid);
    if (pets != null && pets.isNotEmpty) {
      for (var i = 0; i < pets.length; i++) {
        if (pets[i].species == Species.cat) {
          cat = pets[i];
        } else if (pets[i].species == Species.dog) {
          dog = pets[i];
        }
      }
    }
    setState(() {
      cat = cat;
      dog = dog;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: petFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            dog?.printInfo();
            cat?.printInfo();
            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPetInfoScreen(pet: dog, user: user),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.dog,
                                      color: Color.fromARGB(255, 231, 146, 19)),
                                  const SizedBox(width: 12),
                                  Text(
                                    dog != null
                                        ? '${dog!.name} 정보 수정'
                                        : "강아지 추가하기",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.black54)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPetInfoScreen(pet: cat, user: user),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: const Color.fromARGB(255, 240, 240, 240),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.cat,
                                      color: Color.fromARGB(247, 153, 23, 163)),
                                  const SizedBox(width: 12),
                                  Text(
                                    cat != null
                                        ? '${cat!.name} 정보 수정'
                                        : "고양이 추가하기",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.black54)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _authServices.signOut();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(174, 204, 55, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: const Text(
                            '로그아웃',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
