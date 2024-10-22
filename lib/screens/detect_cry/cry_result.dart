import 'package:babystory/enum/cry_state.dart';
import 'package:babystory/models/cry.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';

class CryResultScreen extends StatefulWidget {
  final Cry cryState;

  const CryResultScreen({super.key, required this.cryState});

  @override
  State<CryResultScreen> createState() => _CryResultWidgetState();
}

class _CryResultWidgetState extends State<CryResultScreen> {
  late final DetailInfoRender info;

  @override
  void initState() {
    super.initState();
    info = DetailInfoRender(cryState: widget.cryState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const SimpleClosedAppBar(title: '반려동물 울음 분석'),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              width: width * 0.9,
              height: 159,
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, top: 10),
                        padding: const EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(210, 243, 251, 0.54),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: 100,
                        height: 94,
                        child: info.renderImage(),
                      ),
                      Text(
                        info.raw.iconTitle,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  info.renderIconDesc(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              cryStateEnToKr[widget.cryState.state] ?? '',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            info.renderPredictionInfo(width),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              width: width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                ),
                child: info.renderDescription(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailInfoRender {
  final Cry cryState;
  final DetailInfo _info;

  DetailInfoRender({required this.cryState})
      : _info = DetailInfoKR().getDetailInfo(cryState.state) {
    _info.updatePredictionMap(cryState.predictMap);
  }

  DetailInfo get raw => _info;

  Column renderDescription() {
    List<Widget> renderList = [];
    var wordList = _info.description.split('\n');
    for (var word in wordList) {
      if (word.isEmpty) {
        renderList.add(const SizedBox(height: 12));
      } else {
        if (word.contains('**')) {
          var richWords = word.split('**');
          List<TextSpan> richRenderList = [];
          for (var i = 0; i < richWords.length; i++) {
            if (i % 2 == 0) {
              richRenderList.add(
                TextSpan(
                  text: richWords[i],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ColorProps.darkBrown,
                  ),
                ),
              );
            } else {
              richRenderList.add(
                TextSpan(
                  text: richWords[i],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(156, 47, 199, 0.988),
                  ),
                ),
              );
            }
          }
          renderList.add(Text.rich(TextSpan(children: richRenderList)));
        } else {
          renderList.add(
            Text(
              word,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorProps.darkBrown,
              ),
            ),
          );
        }
        renderList.add(const SizedBox(height: 12));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: renderList,
    );
  }

  Image renderImage() {
    return Image.asset(_info.iconPath);
  }

  SizedBox renderPredictionInfo(double width) {
    List<String> keys = cryState.predictMap.keys.toList();
    double p1 = cryState.predictMap[keys[0]]!;
    double p2 = cryState.predictMap[keys[1]]!;

    return SizedBox(
      width: width * 0.82,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cryStrStateEnToKr[keys[0]] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                cryStrStateEnToKr[keys[1]] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${(p1 * 100).round()}%',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Container(
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: p1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(222, 252, 185, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${(p2 * 100).round()}%',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Container(
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: p2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: ColorProps.bgPink,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderIconDesc() {
    List<String> descList = _info.iconDesc.split('\n');

    List<Widget> textList = [];
    for (var desc in descList) {
      textList.add(
        Text(
          desc,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      textList.add(const SizedBox(height: 5));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textList,
    );
  }
}

class DetailInfoKR {
  final DetailInfo angerInfo = DetailInfo(
    state: 'Anger',
    predictionMap: {},
    iconPath: 'assets/pets/anger.png',
    iconTitle: '화가 났어요!',
    iconDesc: '반려동물이 으르렁거리거나\n이를 드러내고 있나요?\n혹은 털이 곤두서고\n꼬리를 세우고 있나요?',
    description:
        '반려동물이 화가 났을 때는\n**스트레스**를 받고 있을 가능성이 높아요!\n\n반려동물이 **안정감을 느낄 수 있도록**\n조용하고 편안한 장소를 제공해주세요.\n\n추가적으로 반려동물의 **건강 상태**나\n**필요한 욕구**가 충족되었는지 확인해주세요.',
  );

  final DetailInfo playInfo = DetailInfo(
    state: 'Play',
    predictionMap: {},
    iconPath: 'assets/pets/play.png',
    iconTitle: '놀고 싶어요!',
    iconDesc: '반려동물이 장난감을\n물어오거나\n주인의 주위를 맴돌고\n있나요?',
    description:
        '반려동물이 활발하게 움직이거나\n주의를 끌려고 한다면,\n**놀이 시간을 원하는 것**일 수 있어요!\n\n함께 **장난감으로 놀아주거나**\n산책을 해보세요.\n\n추가적으로 반려동물의 **운동량**이 충분한지\n확인해보는 것도 좋습니다.',
  );

  final DetailInfo happyInfo = DetailInfo(
    state: 'Happy',
    predictionMap: {},
    iconPath: 'assets/pets/happy.png',
    iconTitle: '행복해요!',
    iconDesc: '반려동물이 꼬리를\n살랑살랑 흔들거나\n편안한 표정을 짓고\n있나요?',
    description:
        '반려동물이 편안해 보인다면\n**행복함**을 느끼고 있는 거예요!\n\n이런 순간을 함께 즐기며\n**칭찬**이나 **간식**을 주어\n긍정적인 경험을 강화해주세요.\n\n추가적으로 반려동물과의\n**유대감 형성**에 도움이 됩니다.',
  );

  final DetailInfo sadInfo = DetailInfo(
    state: 'Sad',
    predictionMap: {},
    iconPath: 'assets/pets/sad.png',
    iconTitle: '슬퍼요.',
    iconDesc: '반려동물이 기운이 없고\n식욕이 감소했나요?\n혹은 구석에 숨어\n있나요?',
    description:
        '반려동물이 평소와 다르게\n활동성이 떨어진다면\n**우울함**을 느끼고 있을 수 있어요.\n\n따뜻한 관심과\n**쓰다듬어 주기**로\n반려동물을 위로해주세요.\n\n필요하다면 **수의사와 상담**하여\n전문적인 도움을 받으세요.',
  );

  final DetailInfo hungerInfo = DetailInfo(
    state: 'Hunger',
    predictionMap: {},
    iconPath: 'assets/pets/hunger.png',
    iconTitle: '배가 고파요!',
    iconDesc: '반려동물이 음식 그릇을\n할퀴거나 주인을\n계속 쳐다보나요?',
    description:
        '반려동물이 계속해서\n음식을 찾는다면\n**배고픔**을 느끼고 있을 가능성이 높아요.\n\n**정해진 시간**에\n**적절한 양의 식사**를 제공해주세요.\n\n추가적으로 **간식**을 주어\n영양을 보충해주는 것도 좋습니다.',
  );

  final DetailInfo lonelyInfo = DetailInfo(
    state: 'Lonely',
    predictionMap: {},
    iconPath: 'assets/pets/lonely.png',
    iconTitle: '외로워요.',
    iconDesc: '반려동물이 혼자 있을 때\n짖거나 울부짖나요?\n혹은 집안의 물건을\n망가뜨리나요?',
    description:
        '반려동물이 외로움을 느끼면\n**분리 불안**을 겪을 수 있어요.\n\n함께 있는 시간을 늘리거나\n**장난감**을 제공하여\n심심하지 않게 해주세요.\n\n필요하다면 **전문가의 도움**을 받아\n훈련을 진행해보세요.',
  );

  DetailInfo getDetailInfo(CryState state) {
    switch (state) {
      case CryState.anger:
        return angerInfo;
      case CryState.play:
        return playInfo;
      case CryState.happy:
        return happyInfo;
      case CryState.sad:
        return sadInfo;
      case CryState.hunger:
        return hungerInfo;
      case CryState.lonely:
        return lonelyInfo;
      default:
        throw Exception("Unknown type of baby state");
    }
  }
}

class DetailInfo {
  final String state;
  Map<String, double> predictionMap;
  final String iconPath;
  final String iconDesc;
  final String iconTitle;
  final String description;

  DetailInfo({
    required this.state,
    this.predictionMap = const {'': 0, ' ': 0},
    required this.iconPath,
    required this.iconDesc,
    required this.iconTitle,
    required this.description,
  });

  void updatePredictionMap(Map<String, double> predictMap) {
    predictionMap = predictMap;
  }
}
