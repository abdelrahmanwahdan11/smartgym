import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../data/local_data/local_store.dart';

class FormatService extends GetxService {
  FormatService(this.store);

  final LocalStore store;

  final RxString currencyCode = AppConstants.defaultCurrency.obs;
  final RxDouble fxRate = 1.0.obs;
  final RxBool vatEnabled = true.obs;
  final RxBool arabicDigits = false.obs;
  final RxBool metricUnits = true.obs;

  Future<void> load() async {
    currencyCode.value = store.getString('currency.code') ?? AppConstants.defaultCurrency;
    fxRate.value = double.tryParse(store.getString('currency.fx') ?? '1.0') ?? 1.0;
    vatEnabled.value = store.getBool('vat.enabled') ?? true;
    arabicDigits.value = store.getBool('display.arabic_digits') ?? false;
    metricUnits.value = store.getBool('units.metric') ?? true;
  }

  double convertAmount(double amount, {bool includeVat = true}) {
    var value = amount;
    if (includeVat && vatEnabled.value) {
      value *= (1 + AppConstants.defaultVatRate);
    }
    value *= fxRate.value;
    return value;
  }

  String formatCurrency(double amount, {bool includeVat = true, int decimals = 2}) {
    final converted = convertAmount(amount, includeVat: includeVat);
    final formatted = converted.toStringAsFixed(decimals);
    return '${currencyCode.value} ${_applyDigits(formatted)}';
  }

  String formatNumber(num value, {int decimals = 1}) {
    final fixed = value.toStringAsFixed(decimals);
    return _applyDigits(fixed);
  }

  Future<void> setCurrency(String code) async {
    currencyCode.value = code;
    await store.setString('currency.code', code);
  }

  Future<void> setFxRate(double rate) async {
    fxRate.value = rate <= 0 ? 1.0 : rate;
    await store.setString('currency.fx', fxRate.value.toString());
  }

  Future<void> toggleVat(bool enabled) async {
    vatEnabled.value = enabled;
    await store.setBool('vat.enabled', enabled);
  }

  Future<void> toggleArabicDigits(bool enabled) async {
    arabicDigits.value = enabled;
    await store.setBool('display.arabic_digits', enabled);
  }

  Future<void> toggleMetric(bool enabled) async {
    metricUnits.value = enabled;
    await store.setBool('units.metric', enabled);
  }

  String _applyDigits(String input) {
    if (!arabicDigits.value) return input;
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var output = input;
    for (var i = 0; i < western.length; i++) {
      output = output.replaceAll(western[i], eastern[i]);
    }
    return output;
  }

  static FormatService get to => Get.find<FormatService>();
}
