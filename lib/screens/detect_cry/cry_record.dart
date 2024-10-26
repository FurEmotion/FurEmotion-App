import 'package:babystory/apis/cry_api.dart';
import 'package:babystory/apis/raw.api.dart';
import 'package:babystory/models/cry.dart';
import 'package:babystory/models/pet.dart';
import 'package:babystory/models/user.dart';
import 'package:babystory/providers/user_provider.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/utils/data_genderator.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/cry_record_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CryRecordScreen extends StatefulWidget {
  final Pet pet;

  const CryRecordScreen({super.key, required this.pet});

  @override
  State<CryRecordScreen> createState() => _CryRecordScreenState();
}

class _CryRecordScreenState extends State<CryRecordScreen> {
  late DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  late DateTime endDate = DateTime.now();
  List<Cry> cries = [];
  late CryApi cryApi;
  late User user;

  User getUserFromProvider() {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      throw Exception('User is null');
    }
    return user;
  }

  Future<void> getCries() async {
    var criesData = await cryApi.getCriesBetweenTime(
        petId: widget.pet.id, startTime: startDate, endTime: endDate);
    setState(() {
      cries = criesData;
    });
  }

  @override
  void initState() {
    super.initState();
    user = getUserFromProvider();
    cryApi = CryApi(jwt: user.jwt!);
    getCries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleClosedAppBar(title: '울음 저장소'),
        backgroundColor: ColorProps.bgLightGray,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '울음 저장소',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ColorProps.textBlack),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorProps.bgPink,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      color: ColorProps.orangeYellow,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      // backgroundImage: NetworkImage(
                      //     RawsApi.getProfileLink(widget.pet.photoId)),
                      backgroundImage: NetworkImage(
                          RawApi.getPetProfileLink(widget.pet.id.toString())),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 72,
                    child: Text(
                      '시작 날짜: ',
                      style: TextStyle(
                          color: ColorProps.textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    width: 220,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: ColorProps.textgray,
                      width: 0.5,
                    ))),
                    child: TextButton(
                      onPressed: () => showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2000),
                              lastDate: endDate)
                          .then((selectedDate) {
                        setState(() {
                          if (selectedDate != null) {
                            startDate = selectedDate;
                          }
                        });
                      }),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(startDate),
                        style: const TextStyle(color: ColorProps.textBlack),
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(
                    width: 72,
                    child: Text(
                      '종료 날짜: ',
                      style: TextStyle(
                          color: ColorProps.textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    width: 220,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: ColorProps.textgray,
                      width: 0.5,
                    ))),
                    child: TextButton(
                      onPressed: () => showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: DateTime(2000),
                              lastDate: endDate)
                          .then((selectedDate) {
                        setState(() {
                          if (selectedDate != null) {
                            endDate = selectedDate;
                          }
                        });
                      }),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(endDate),
                        style: const TextStyle(color: ColorProps.textBlack),
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => getCries(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorProps.bgOrange),
                          child: const Text("조회하기",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)))),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: CryRecordList(cries: cries)),
            ],
          ),
        ));
  }
}
