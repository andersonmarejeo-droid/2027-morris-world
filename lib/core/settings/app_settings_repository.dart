import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings_models.dart';

abstract interface class AppSettingsRepository {
  Future<AppSettingsState> load();
  Future<void> save(AppSettingsState state);
}

class SharedPreferencesAppSettingsRepository implements AppSettingsRepository {
  static const _localeLanguageKey = 'settings.locale.language';
  static const _localeCountryKey = 'settings.locale.country';
  static const _soundKey = 'settings.sound';
  static const _hapticKey = 'settings.haptic';
  static const _reduceMotionKey = 'settings.reduceMotion';
  static const _showMoveHintsKey = 'settings.showMoveHints';
  static const _colorAssistKey = 'settings.colorAssist';
  static const _boardViewKey = 'settings.boardView';
  static const _boardSurfaceKey = 'settings.boardSurface';
  static const _pieceThemeKey = 'settings.pieceTheme';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  Future<AppSettingsState> load() async {
    final language = await _prefs.getString(_localeLanguageKey);
    final country = await _prefs.getString(_localeCountryKey);
    final locale = language == null || language.isEmpty
        ? null
        : Locale(language, country == null || country.isEmpty ? null : country);

    return AppSettingsState(
      locale: locale,
      soundEnabled: await _prefs.getBool(_soundKey) ?? true,
      hapticEnabled: await _prefs.getBool(_hapticKey) ?? true,
      reduceMotion: await _prefs.getBool(_reduceMotionKey) ?? false,
      showMoveHints: await _prefs.getBool(_showMoveHintsKey) ?? true,
      colorAssist: await _prefs.getBool(_colorAssistKey) ?? true,
      boardView: _enumByName(
        BoardViewStyle.values,
        await _prefs.getString(_boardViewKey),
        BoardViewStyle.realistic,
      ),
      boardSurface: _enumByName(
        BoardSurface.values,
        await _prefs.getString(_boardSurfaceKey),
        BoardSurface.wood,
      ),
      pieceTheme: _enumByName(
        PieceTheme.values,
        await _prefs.getString(_pieceThemeKey),
        PieceTheme.classic,
      ),
    );
  }

  @override
  Future<void> save(AppSettingsState state) async {
    final locale = state.locale;
    if (locale == null) {
      await _prefs.remove(_localeLanguageKey);
      await _prefs.remove(_localeCountryKey);
    } else {
      await _prefs.setString(_localeLanguageKey, locale.languageCode);
      if (locale.countryCode == null) {
        await _prefs.remove(_localeCountryKey);
      } else {
        await _prefs.setString(_localeCountryKey, locale.countryCode!);
      }
    }
    await _prefs.setBool(_soundKey, state.soundEnabled);
    await _prefs.setBool(_hapticKey, state.hapticEnabled);
    await _prefs.setBool(_reduceMotionKey, state.reduceMotion);
    await _prefs.setBool(_showMoveHintsKey, state.showMoveHints);
    await _prefs.setBool(_colorAssistKey, state.colorAssist);
    await _prefs.setString(_boardViewKey, state.boardView.name);
    await _prefs.setString(_boardSurfaceKey, state.boardSurface.name);
    await _prefs.setString(_pieceThemeKey, state.pieceTheme.name);
  }

  T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
    if (name == null) return fallback;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}
