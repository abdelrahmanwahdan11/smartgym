import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import 'mixins/guarded_controller_mixin.dart';

class FormattingController extends GetxController with GuardedControllerMixin {
  FormattingController(this._formatService);

  final FormatService _formatService;

  RxString get currency => _formatService.currencyCode;
  RxDouble get fxRate => _formatService.fxRate;
  RxBool get vatEnabled => _formatService.vatEnabled;
  RxBool get arabicDigits => _formatService.arabicDigits;
  RxBool get metricUnits => _formatService.metricUnits;

  @override
  void onInit() {
    super.onInit();
    _formatService.load();
  }

  Future<void> setCurrency(String code) => _formatService.setCurrency(code);

  Future<void> setFx(double value) => _formatService.setFxRate(value);

  Future<void> toggleVat(bool enabled) => _formatService.toggleVat(enabled);

  Future<void> toggleDigits(bool enabled) => _formatService.toggleArabicDigits(enabled);

  Future<void> toggleUnits(bool metric) => _formatService.toggleMetric(metric);
}
