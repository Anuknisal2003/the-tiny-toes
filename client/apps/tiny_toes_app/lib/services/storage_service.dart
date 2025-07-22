
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences prefs;
  StorageService(this.prefs);

  String? get username => prefs.getString('username');

  Future<void> saveUsername(String username) =>
      prefs.setString('username', username);

  Future<void> clear() => prefs.clear();
}
