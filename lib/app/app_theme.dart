import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

/// Shared visual language for every game and utility screen.
///
/// The app currently starts in the light theme, while [dark] is kept ready for
/// a future preference without requiring individual screens to be redesigned.
abstract final class AppTheme {
  static ThemeData light() => _build(
    scheme: const ColorScheme.light(
      primary: AppColors.brandDeep,
      onPrimary: Colors.white,
      secondary: AppColors.brandTop,
      onSecondary: Colors.white,
      tertiary: AppColors.selection,
      onTertiary: AppColors.ink,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.danger,
      onError: Colors.white,
      outline: AppColors.lineStrong,
    ),
    cardColor: AppColors.card,
    mutedSurface: AppColors.surfaceMuted,
    mutedInk: AppColors.inkMuted,
    divider: AppColors.line,
  );

  static ThemeData dark() => _build(
    scheme: const ColorScheme.dark(
      primary: AppColors.brandHighlight,
      onPrimary: AppColors.brandTop,
      secondary: AppColors.selection,
      onSecondary: AppColors.ink,
      tertiary: AppColors.target,
      onTertiary: AppColors.ink,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.inkOnDark,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      outline: Color(0xFF526563),
    ),
    cardColor: AppColors.surfaceDarkRaised,
    mutedSurface: const Color(0xFF24383A),
    mutedInk: AppColors.inkMutedOnDark,
    divider: const Color(0xFF38504F),
  );

  static ThemeData _build({
    required ColorScheme scheme,
    required Color cardColor,
    required Color mutedSurface,
    required Color mutedInk,
    required Color divider,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    final roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      borderSide: BorderSide(color: scheme.outline),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamilyFallback: const ['Noto Sans', 'Roboto', 'Arial', 'sans-serif'],
      dividerColor: divider,
      disabledColor: mutedInk.withValues(alpha: 0.38),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: CardThemeData(
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.large),
          side: BorderSide(color: divider),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.25,
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, space: 1, thickness: 1),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.1,
        ),
        headlineLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.55,
        ),
        headlineSmall: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.35,
        ),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.42),
        bodyMedium: TextStyle(color: scheme.onSurface, height: 1.4),
        bodySmall: TextStyle(color: mutedInk, height: 1.35),
        labelLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: mutedInk,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelSmall: TextStyle(
          color: mutedInk,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: mutedSurface,
          disabledForegroundColor: mutedInk.withValues(alpha: 0.65),
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size.square(AppConstraints.minTapTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mutedSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: TextStyle(color: mutedInk),
        hintStyle: TextStyle(color: mutedInk.withValues(alpha: 0.78)),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        border: roundedBorder,
        enabledBorder: roundedBorder,
        focusedBorder: roundedBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: roundedBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: mutedSurface,
        selectedColor: scheme.primary.withValues(alpha: isDark ? 0.30 : 0.12),
        disabledColor: mutedSurface,
        side: BorderSide(color: divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? scheme.onPrimary
                  : mutedInk,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? scheme.primary
                  : mutedSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: cardColor,
        modalBarrierColor: AppColors.scrim.withValues(alpha: 0.52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.extraLarge),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.extraLarge),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.inkOnDark : AppColors.ink,
        contentTextStyle: TextStyle(
          color: isDark ? AppColors.ink : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: mutedSurface,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.scrim,
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
