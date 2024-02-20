import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/features/home/views/home_view.dart';
import 'package:viet_qr_plugin/features/login/repositories/login_repository.dart';
import 'package:viet_qr_plugin/models/account_login_dto.dart';
import 'package:viet_qr_plugin/utils/encrypt_utils.dart';
import 'package:viet_qr_plugin/utils/log.dart';
import 'package:viet_qr_plugin/widgets/button_widget.dart';
import 'package:viet_qr_plugin/widgets/dialog_widget.dart';
import 'package:viet_qr_plugin/widgets/pin_code_input.dart';

class PaswordInputWidget extends StatefulWidget {
  final double width;
  final double height;
  final String phoneNo;
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  LoginRepository loginRepository = const LoginRepository();

  PaswordInputWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.phoneNo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordInputWidget();
}

class _PasswordInputWidget extends State<PaswordInputWidget> {
  bool _isEnableButton = false;
  bool _isErrPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          PinCodeInput(
            obscureText: true,
            controller: widget.passwordController,
            autoFocus: true,
            focusNode: widget.passwordFocus,
            onChanged: (text) {
              if (widget.passwordController.text.length == 6) {
                setState(() {
                  _isEnableButton = true;
                });
              } else {
                setState(() {
                  _isEnableButton = false;
                });
              }
            },
            onCompleted: (value) async {
              await login(widget.phoneNo, widget.passwordController.text);
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Visibility(
            visible: _isErrPassword,
            child: const Text(
              'Mật khẩu không chínhh xác, vui lòng thử lại.',
              style: TextStyle(
                fontSize: 13,
                color: AppColor.RED_TEXT,
              ),
            ),
          ),
          const Spacer(),
          ButtonWidget(
            width: widget.width,
            height: 40,
            borderRadius: 5,
            text: 'Đăng nhập',
            textColor: (_isEnableButton) ? AppColor.WHITE : AppColor.BLACK,
            bgColor:
                (_isEnableButton) ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON,
            function: () async {
              await login(widget.phoneNo, widget.passwordController.text);
            },
          )
        ],
      ),
    );
  }

  Future<void> login(String phoneNo, String password) async {
    try {
      String passwordEncrypted =
          EncryptUtils.instance.encrypted(phoneNo, password);
      AccountLoginDTO dto = AccountLoginDTO(
        phoneNo: phoneNo,
        password: passwordEncrypted,
        platform: '',
        device: '',
        fcmToken: '',
        sharingCode: '',
      );
      //open loading dialog
      DialogWidget.instance.openLoadingDialog();
      //call login method
      bool result = await widget.loginRepository.login(dto);
      //pop loading dialog
      Navigator.pop(context);
      //
      if (result) {
        setState(() {
          _isErrPassword = false;
        });
        //navigate to home
        print('navigate to home');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeView(),
          ),
        );
      } else {
        //notify wrong password
        print('wrong password');
        setState(() {
          widget.passwordController.clear();
          widget.passwordFocus.requestFocus();
          _isErrPassword = true;
        });
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
