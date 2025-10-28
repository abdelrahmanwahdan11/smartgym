import 'package:get/get.dart';

/// Common form validators used across the application.
class AppValidators {
  const AppValidators._();

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required'.tr;
    }
    return null;
  }

  static String? email(String? value) {
    final requiredResult = requiredField(value);
    if (requiredResult != null) {
      return requiredResult;
    }
    final email = value!.trim();
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
    if (!emailRegex.hasMatch(email)) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  static String? minLength(String? value, int length) {
    final requiredResult = requiredField(value);
    if (requiredResult != null) {
      return requiredResult;
    }
    if (value!.trim().length < length) {
      return 'min_6_chars'.tr;
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final requiredResult = requiredField(value);
    if (requiredResult != null) {
      return requiredResult;
    }
    final parsed = double.tryParse(value!.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'invalid_number'.tr;
    }
    return null;
  }
}
