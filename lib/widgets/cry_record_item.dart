import 'package:babystory/enum/cry_intensity.dart';
import 'package:babystory/enum/cry_state.dart';
import 'package:babystory/models/cry.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babystory/widgets/expandsion_tile_card.dart';

class CryRecordListItem extends StatefulWidget {
  final Cry cry;
  late bool initiallyExpanded;

  CryRecordListItem(
      {super.key, required this.cry, this.initiallyExpanded = false});

  @override
  State<CryRecordListItem> createState() => _CryRecordListItemState();
}

class _CryRecordListItemState extends State<CryRecordListItem> {
  DateFormat bannerDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat detailDateFormat = DateFormat("yyyy년 MM월 dd일 HH시 mm분 ss초");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ExpansionTileCard(
        initiallyExpanded: widget.initiallyExpanded,
        baseColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        key: GlobalKey(),
        leading: CircleAvatar(
            radius: 24,
            backgroundColor: ColorProps.bgBlue,
            child: Image.asset(
              'assets/pets/${cryStateEnToEnStr[widget.cry.state]}.png',
              width: 36,
              height: 36,
            )),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(cryStateEnToKr[widget.cry.state] ?? '',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
        ]),
        subtitle: Text(bannerDateFormat.format(widget.cry.time),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detailDateFormat.format(widget.cry.time),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            _intensityAndTimeWidget(
                                widget.cry.intensity, widget.cry.duration),
                          ],
                        ),
                      ),
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow_rounded),
                            color: Colors.white,
                            iconSize: 24,
                          )),
                      const SizedBox(width: 3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  renderPredictionInfo(widget.cry, 250),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _intensityAndTimeWidget(CryIntensity intensity, double? cryTime) {
    cryTime = cryTime ?? 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("울음 강도:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(width: 3),
        Text(cryIntensityEnToKr[intensity]!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: intensity == CryIntensity.high
                  ? FontWeight.bold
                  : FontWeight.w400,
              color: intensity == CryIntensity.low
                  ? Colors.blue
                  : intensity == CryIntensity.medium
                      ? Colors.orange[700]
                      : Colors.red,
            )),
        const SizedBox(width: 8),
        const Text('][',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: ColorProps.gray)),
        const SizedBox(width: 8),
        const Text("울음 시간:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(width: 3),
        Text("${cryTime.toStringAsFixed(1)}초",
            style: TextStyle(
              fontSize: 12,
              fontWeight: cryTime > 11 ? FontWeight.bold : FontWeight.w400,
              color: cryTime < 6
                  ? Colors.blue
                  : cryTime < 11
                      ? Colors.orange[700]
                      : Colors.red,
            )),
      ],
    );
  }

  SizedBox renderPredictionInfo(Cry cry, double width) {
    List<String> keys = cry.predictMap.keys.toList();
    double p1 = cry.predictMap[keys[0]]!;
    double p2 = cry.predictMap[keys[1]]!;
    double p3 = cry.predictMap[keys[2]]!;

    return SizedBox(
      width: width * 0.82,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cryStrStateEnToKr[keys[0]]!,
                  style: const TextStyle(
                    fontSize: 13,
                  )),
              const SizedBox(height: 13),
              Text(cryStrStateEnToKr[keys[1]]!,
                  style: const TextStyle(
                    fontSize: 13,
                  )),
              const SizedBox(height: 13),
              Text(cryStrStateEnToKr[keys[2]]!,
                  style: const TextStyle(
                    fontSize: 13,
                  )),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p1 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width * 0.5 * p1,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(222, 252, 185, 1),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p2 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width * 0.5 * p2,
                    decoration: const BoxDecoration(
                      color: ColorProps.bgBrown,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('${(p3 * 100).round()}%')])),
                  const SizedBox(width: 7),
                  Container(
                    height: 15,
                    width: width * 0.5 * p3,
                    decoration: const BoxDecoration(
                      color: ColorProps.bgPink,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
