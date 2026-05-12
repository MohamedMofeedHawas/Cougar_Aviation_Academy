import 'package:shared_preferences/shared_preferences.dart';

/// [PrefsService] is a wrapper around [SharedPreferences] for persistent
/// lightweight storage like theme settings, locale, and onboarding status.
class PrefsService {
  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _tokenKey = 'auth_token';

  /// Returns true if this is the first time the app is launched.
  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;

  /// Sets the first launch flag.
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_isFirstLaunchKey, value);
  }

  /// Returns the stored theme mode (dark/light).
  String get themeMode => _prefs.getString(_themeModeKey) ?? 'dark';

  /// Sets the theme mode.
  Future<void> setThemeMode(String value) async {
    await _prefs.setString(_themeModeKey, value);
  }

  /// Returns the stored locale.
  String get locale => _prefs.getString(_localeKey) ?? 'en';

  /// Sets the locale.
  Future<void> setLocale(String value) async {
    await _prefs.setString(_localeKey, value);
  }

  /// Returns the stored auth token.
  String? get token => _prefs.getString(_tokenKey);

  /// Sets the auth token.
  Future<void> setToken(String? value) async {
    if (value == null) {
      await _prefs.remove(_tokenKey);
    } else {
      await _prefs.setString(_tokenKey, value);
    }
  }

  /// Clears all stored preferences.
  Future<void> clear() async {
    await _prefs.clear();
  }
}
