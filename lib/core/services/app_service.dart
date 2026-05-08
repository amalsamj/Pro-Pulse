import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService extends GetxService {
  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _isLoggedInKey = 'is_logged_in';

  SharedPreferences? _preferences;

  Future<AppService> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    return this;
  }

  bool get hasSeenOnboarding =>
      _preferences?.getBool(_hasSeenOnboardingKey) ?? false;

  bool get isLoggedIn => _preferences?.getBool(_isLoggedInKey) ?? false;

  Future<void> markOnboardingSeen() async {
    await _preferences?.setBool(_hasSeenOnboardingKey, true);
  }

  Future<void> setLoggedIn(bool value) async {
    await _preferences?.setBool(_isLoggedInKey, value);
  }

  Future<void> logout() => setLoggedIn(false);
}
