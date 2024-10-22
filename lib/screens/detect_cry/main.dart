import 'package:babystory/enum/species.dart';
import 'package:flutter/material.dart';

class DetectCryMainScreen extends StatefulWidget {
  final Species species;

  const DetectCryMainScreen({required this.species, super.key});

  @override
  State<DetectCryMainScreen> createState() => _DetectCryMainScreenState();
}

class _DetectCryMainScreenState extends State<DetectCryMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Detect ${widget.species} cry."),
    );
  }
}
