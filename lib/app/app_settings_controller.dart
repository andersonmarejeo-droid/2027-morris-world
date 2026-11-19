import 'package:flutter/widgets.dart';

import '../core/settings/app_settings_models.dart';
import '../core/settings/app_settings_repository.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController(
    this._repository, {
    AppSettingsState initialState = const AppSettingsState(),
  }) : _state = initialState;

  final AppSettingsRepository _repository;
  AppSettingsState _state;
  AppSettingsState get state => _state;

  Future<void> _saveChain = Future<void>.value();

  Future<void> initialize() async {
    _state = await _repository.load();
    notifyListeners();
  }

  Future<void> useSystemLanguage() => _update(_state.copyWith(clearLocale: true));
  Future<void> setLocale(Locale locale) => _update(_state.copyWith(locale: locale));
  Future<void> setSoundEnabled(bool value) => _update(_state.copyWith(soundEnabled: value));
  Future<void> setHapticEnabled(bool value) => _update(_state.copyWith(hapticEnabled: value));
  Future<void> setReduceMotion(bool value) => _update(_state.copyWith(reduceMotion: value));
  Future<void> setShowMoveHints(bool value) => _update(_state.copyWith(showMoveHints: value));
  Future<void> setColorAssist(bool value) => _update(_state.copyWith(colorAssist: value));
  Future<void> setBoardView(BoardViewStyle value) => _update(_state.copyWith(boardView: value));
  Future<void> setBoardSurface(BoardSurface value) => _update(_state.copyWith(boardSurface: value));
  Future<void> setPieceTheme(PieceTheme value) => _update(_state.copyWith(pieceTheme: value));

  Future<void> _update(AppSettingsState next) {
    _state = next;
    notifyListeners();
    final snapshot = next;
    _saveChain = _saveChain.then(
      (_) => _repository.save(snapshot),
      onError: (_) => _repository.save(snapshot),
    );
    return _saveChain;
  }
}
