import 'package:viet_qr_plugin/main.dart';

class AccountHelper {
  const AccountHelper._privateConsrtructor();

  static const AccountHelper _instance = AccountHelper._privateConsrtructor();
  static AccountHelper get instance => _instance;

  Future<void> initialAccountHelper() async {
    await sharedPrefs.setString('TOKEN', '');
    await sharedPrefs.setString('FCM_TOKEN', '');
    await sharedPrefs.setString('TOKEN_FREE', '');
  }

  Future<void> setToken(String value) async {
    await sharedPrefs.setString('TOKEN', value);
  }

  String getToken() {
    return sharedPrefs.getString('TOKEN')!;
  }

  Future<void> setFcmToken(String token) async {
    await sharedPrefs.setString('FCM_TOKEN', token);
  }

  Future<void> setTokenFree(String value) async {
    await sharedPrefs.setString('TOKEN_FREE', value);
  }

  String getTokenFree() {
    return sharedPrefs.getString('TOKEN_FREE') ?? '';
  }
}
