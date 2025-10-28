import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ShareCardController extends GetxController {
  final GlobalKey repaintKey = GlobalKey();

  final RxBool showName = true.obs;
  final RxBool showStats = true.obs;
  final RxBool showBadges = true.obs;
  final RxBool showGym = true.obs;
  final RxBool showChallenges = true.obs;
  final RxString template = 'classic'.obs;
  final RxDouble textScale = 1.0.obs;

  Future<ByteData?> exportPng() async {
    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  void toggleName(bool value) => showName.value = value;

  void toggleStats(bool value) => showStats.value = value;

  void toggleBadges(bool value) => showBadges.value = value;

  void toggleGym(bool value) => showGym.value = value;

  void toggleChallenges(bool value) => showChallenges.value = value;

  void setTemplate(String value) => template.value = value;

  void setTextScale(double value) => textScale.value = value;
}
