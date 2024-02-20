import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/features/login/views/login_view.dart';
import 'package:viet_qr_plugin/services/shared_preferences/account_helper.dart';
import 'package:viet_qr_plugin/services/shared_preferences/user_information_helper.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  //
  runApp(const VietQRPlugin());
}

Future<void> _initialServiceHelper() async {
  if (!sharedPrefs.containsKey('TOKEN') ||
      sharedPrefs.getString('TOKEN') == null) {
    await AccountHelper.instance.initialAccountHelper();
  }
  if (!sharedPrefs.containsKey('USER_ID') ||
      sharedPrefs.getString('USER_ID') == null) {
    await UserHelper.instance.initialUserInformationHelper();
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class VietQRPlugin extends StatefulWidget {
  const VietQRPlugin({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRPlugin();
}

class _VietQRPlugin extends State<VietQRPlugin> {
  static Widget _mainScreen = const LoginView();

  String get userId => UserHelper.instance.getUserId().trim();

  @override
  void initState() {
    super.initState();
    _mainScreen = (userId.isNotEmpty) ? const HomeView() : const LoginView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      home: _mainScreen,
    );
  }
}
