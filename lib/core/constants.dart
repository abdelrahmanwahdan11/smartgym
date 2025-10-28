class AppConstants {
  AppConstants._();

  static const double defaultVatRate = 0.17;
  static const String defaultCurrency = 'USD';
  static const double animationThreshold = 0.85;
  static const int paginationPageSize = 10;
  static const int maxActionLogEntries = 300;
  static const Duration pinCooldown = Duration(seconds: 30);

  // Design tokens (v6)
  static const double radiusXl = 28;
  static const double radiusLg = 20;
  static const double radiusMd = 14;
  static const double radiusSm = 10;

  static const double spacingXs = 6;
  static const double spacingSm = 10;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  static const Duration animationFast = Duration(milliseconds: 120);
  static const Duration animationMed = Duration(milliseconds: 260);
  static const Duration animationSlow = Duration(milliseconds: 420);

  static const double breakpointPhoneMax = 599;
  static const double breakpointTabletMin = 600;
  static const double breakpointDesktopMin = 1024;
}
