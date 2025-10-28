import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData light(Color primary, {bool highContrast = false}) =>
      _buildTheme(primary, Brightness.light, highContrast: highContrast);

  static ThemeData dark(Color primary, {bool highContrast = false}) =>
      _buildTheme(primary, Brightness.dark, highContrast: highContrast);

  static ThemeData _buildTheme(
    Color primary,
    Brightness brightness, {
    required bool highContrast,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );
    final textTheme = _textTheme(brightness, highContrast: highContrast);
    final surfaceColor = brightness == Brightness.light
        ? const Color(0xFFF8F9FB)
        : const Color(0xFF0E1113);
    final cardColor = brightness == Brightness.light
        ? Colors.white.withOpacity(0.92)
        : colorScheme.surfaceVariant.withOpacity(0.4);

    final borderRadius = BorderRadius.circular(AppConstants.radiusLg);

    const tokens = AppTokens(
      spacingXs: AppConstants.spacingXs,
      spacingSm: AppConstants.spacingSm,
      spacingMed: AppConstants.spacingMd,
      spacingLg: AppConstants.spacingLg,
      spacingXl: AppConstants.spacingXl,
      animationFast: AppConstants.animationFast,
      animationMed: AppConstants.animationMed,
      animationSlow: AppConstants.animationSlow,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: surfaceColor,
      canvasColor: surfaceColor,
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        shadowColor: Colors.black.withOpacity(0.08),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: textTheme.titleLarge?.color,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      chipTheme: ChipThemeData(
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSm,
          vertical: AppConstants.spacingXs,
        ),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        selectedColor: colorScheme.primary.withOpacity(0.12),
        disabledColor: colorScheme.surfaceVariant.withOpacity(0.3),
        backgroundColor: colorScheme.surfaceVariant.withOpacity(
          brightness == Brightness.light ? 0.55 : 0.35,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.all(textTheme.labelMedium),
        elevation: 1,
        backgroundColor: surfaceColor,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme:
            IconThemeData(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
      ),
      drawerTheme: DrawerThemeData(
        elevation: 0,
        backgroundColor: surfaceColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingSm,
          ),
          animationDuration: AppConstants.animationFast,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingSm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? Colors.white
            : colorScheme.surfaceVariant.withOpacity(0.25),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.2)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
      ),
      dividerColor: colorScheme.outlineVariant.withOpacity(0.4),
      dialogTheme: DialogTheme(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyLarge,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      extensions: const <ThemeExtension<dynamic>>[tokens],
    );
  }

  static TextTheme _textTheme(
    Brightness brightness, {
    required bool highContrast,
  }) {
    final baseColor = brightness == Brightness.light
        ? (highContrast ? const Color(0xFF0A0C0F) : const Color(0xFF1B1F23))
        : (highContrast ? Colors.white : const Color(0xFFE9ECF1));
    final secondaryColor = brightness == Brightness.light
        ? baseColor.withOpacity(0.75)
        : baseColor.withOpacity(0.82);

    final fallbackFamily = GoogleFonts.tajawal().fontFamily;

    TextStyle style(double size, FontWeight weight,
            {double height = 1.25, Color? color}) =>
        GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: weight >= FontWeight.w600 ? -0.2 : 0,
          color: color ?? baseColor,
        ).copyWith(
          fontFamilyFallback:
              fallbackFamily == null ? null : <String>[fallbackFamily],
        );

    return TextTheme(
      displayLarge: style(30, FontWeight.w700, height: 1.15),
      displayMedium: style(26, FontWeight.w600, height: 1.18),
      headlineLarge: style(24, FontWeight.w600),
      headlineMedium: style(22, FontWeight.w600),
      headlineSmall: style(20, FontWeight.w600),
      titleLarge: style(18, FontWeight.w600),
      titleMedium: style(16, FontWeight.w600, color: secondaryColor),
      titleSmall: style(14, FontWeight.w600, color: secondaryColor),
      bodyLarge: style(16, FontWeight.w400, height: 1.5),
      bodyMedium: style(14, FontWeight.w400, height: 1.5, color: secondaryColor),
      bodySmall: style(13, FontWeight.w400, height: 1.4, color: secondaryColor),
      labelLarge: style(14, FontWeight.w600, height: 1.2),
      labelMedium: style(12, FontWeight.w500, height: 1.2, color: secondaryColor),
      labelSmall: style(11, FontWeight.w500, height: 1.1, color: secondaryColor),
    );
  }
}
