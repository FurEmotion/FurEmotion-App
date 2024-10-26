import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:babystory/apis/pet_api.dart';
import 'package:babystory/enum/species.dart';
import 'package:babystory/models/cry.dart';
import 'package:babystory/models/pet.dart';
import 'package:babystory/models/user.dart';
import 'package:babystory/providers/audio_processor.dart';
import 'package:babystory/providers/user_provider.dart';
import 'package:babystory/screens/detect_cry/cry_analyst.dart';
import 'package:babystory/screens/detect_cry/cry_record.dart';
import 'package:babystory/screens/detect_cry/cry_result.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/utils/os.dart';
import 'package:babystory/widgets/button/bold_center_rounded_button.dart';
import 'package:babystory/widgets/circle_hollow_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum ListenState {
  init,
  listening,
  silence,
  crying,
  analysing,
  done,
}

class CryDetectScreen extends StatefulWidget {
  final Species species;

  const CryDetectScreen({Key? key, required this.species}) : super(key: key);

  @override
  State<CryDetectScreen> createState() => _CryDetectWidgetState();
}

class _CryDetectWidgetState extends State<CryDetectScreen>
    with TickerProviderStateMixin {
  final HttpUtils httpUtils = HttpUtils();
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late SvgPicture mainSvg;
  late ListenState listenState;
  late User user;
  late PetApi petApi;
  late Future<Pet?> petFuture;
  Pet? pet;

  late AudioProcessor _audioProcessor;
  bool isListening = false;

  User getUserFromProvider() {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      throw Exception('User is null');
    }
    return user;
  }

  Future<Pet?> getUserPet() async {
    var pets = await petApi.getUserPets(userId: user.uid);
    Pet? petData;
    if (pets != null && pets.isNotEmpty) {
      for (var i = 0; i < pets.length; i++) {
        if (pets[i].species == widget.species) {
          petData = pets[i];
        }
      }
    }
    setState(() {
      pet = petData;
    });
    return petData;
  }

  @override
  void initState() {
    super.initState();
    user = getUserFromProvider();
    petApi = PetApi(jwt: user.jwt ?? '');
    petFuture = getUserPet();

    listenState = ListenState.init;
    var species = widget.species == Species.dog ? 'dog' : 'cat';
    mainSvg = SvgPicture.asset('assets/icons/$species-black.svg');

    _rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.fastOutSlowIn),
    )..addListener(() {
        setState(() {});
      });

    _audioProcessor = AudioProcessor(
      isListening: () => isListening,
      species: widget.species,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  String getMainSvgPath(ListenState state) {
    switch (state) {
      case ListenState.init:
        var species = widget.species == Species.dog ? 'dog' : 'cat';
        return 'assets/icons/$species-black.svg';
      case ListenState.analysing:
        return 'assets/icons/sound_analyzing-color.svg';
      case ListenState.done:
        return 'assets/icons/check_circle-color.svg';
      default:
        return 'assets/icons/sound_wave-color.svg';
    }
  }

  String getTitle(ListenState state) {
    switch (state) {
      case ListenState.init:
        return '터치하여 시작하기!';
      case ListenState.listening:
        return '소리에 귀를 기울이고 있어요';
      case ListenState.silence:
        return '반려동물이 자고 있어요';
      case ListenState.crying:
        return '반려동물이 울고 있어요!!';
      case ListenState.analysing:
        return '반려동물의 울음 원인 분석 중!';
      case ListenState.done:
        return '분석 완료!';
    }
  }

  void setListenStateWithRef(ListenState toListenState) {
    _scaleController.forward().then((_) {
      setState(() {
        listenState = toListenState;
        isListening = toListenState == ListenState.listening;
        mainSvg = SvgPicture.asset(getMainSvgPath(listenState));
      });
      _scaleController.reverse().then((_) {
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
      });
    });
  }

  void toggleListening() {
    listenState == ListenState.init ? startListening() : endListening();
  }

  void startListening() {
    debugPrint("Start listening");
    setListenStateWithRef(ListenState.listening);
    _audioProcessor.waitForSoundAndAnalyze(
      onAnalysisStarted: () {
        setListenStateWithRef(ListenState.analysing);
        _rotationController.repeat();
      },
      onAnalysisComplete: onAnalysisComplete,
    );
  }

  void onAnalysisComplete(String filePath) async {
    // Check if the file exists
    debugPrint("Send to server with file $filePath");
    if (OsUtils.isFileExist(filePath) == false) {
      throw OSError('Audio file $filePath not exist');
    }

    // Send the file to the server and get predictState
    if (pet == null) {
      return;
    }
    var json = await httpUtils.postMultipart(
        url: '/cry/predict?pet_id=${pet!.id}',
        headers: {'Authorization': 'Bearer ${user.jwt ?? ''}'},
        filePath: filePath);
    if (json == null) {
      return;
    }
    print("cry detect res: $json");
    Cry cry = Cry.fromJson(json['cry']);
    // Cry predictState = Cry(
    //     id: 1,
    //     petId: 1,
    //     time: DateTime.now(),
    //     state: CryState.hunger,
    //     audioId: '1.wav',
    //     predictMap: {
    //       'hunger': 0.82,
    //       'sad': 0.1,
    //       'angry': 0.05,
    //     },
    //     intensity: CryIntensity.medium,
    //     duration: 2.0);

    // Stop the rotation and update the state
    setListenStateWithRef(ListenState.done);
    _rotationController.stop();

    // move page after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setListenStateWithRef(ListenState.init);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryResultScreen(cryState: cry),
          ));
    });
  }

  void endListening() {
    setListenStateWithRef(ListenState.init);
    _rotationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.species == Species.cat
          ? const Color.fromARGB(247, 242, 211, 244)
          : Colors.orange.withOpacity(0.3),
      body: FutureBuilder<Pet?>(
        future: petFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.species == Species.cat
                        ? const Color.fromARGB(247, 242, 211, 244)
                        : Colors.orange.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTitle(listenState),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AvatarGlow(
                            animate: [ListenState.listening, ListenState.crying]
                                .contains(listenState),
                            endRadius: 160.0,
                            glowColor: Colors.red.shade400,
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: toggleListening,
                              child: Material(
                                shape: const CircleBorder(),
                                elevation: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 252, 252, 252),
                                  ),
                                  child: Transform.scale(
                                    scale: _scaleAnimation.value *
                                        _bounceAnimation.value,
                                    child: mainSvg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (listenState == ListenState.analysing)
                            RotationTransition(
                              turns: _rotationController,
                              child: CustomPaint(
                                painter: CircleHollowPainter(),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 110,
                  right: 0,
                  child: BoldCenterRoundedButton(
                    areaHeight: 66,
                    areaWidthRatio: 0.88,
                    text: "울음 기록 보기",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CryRecordScreen(
                                    pet: snapshot.data!,
                                  )));
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 0,
                  child: BoldCenterRoundedButton(
                    areaHeight: 66,
                    areaWidthRatio: 0.88,
                    text: "울음 분석 보기",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CryAnalystScreen(pet: snapshot.data!)));
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: Text('${speciesEnToKr[widget.species]}를 먼저 등록해주세요.',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )));
          }
        },
      ),
    );
  }
}
