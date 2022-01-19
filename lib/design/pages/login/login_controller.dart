import 'package:flutter/material.dart';
import 'package:tuk_gen/core/providers/auth_provider.dart';
import 'package:tuk_gen/core/utils/snackbar.dart';

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();


  TextEditingController phoneController = new TextEditingController();
  AuthProvider _authProvider;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider(context);
  }

  void loginWithGoogle() async {
    await _authProvider.signInWithGoogle();
  }

  void loginWithFacebook() async {
    await _authProvider.signInWithFacebook();
  }

  void loginWithPhone() async {
    String phone = phoneController.text.trim();
    if (phone.length == 10) {
      await _authProvider.signInWithPhone(phone);
    } else {
      Snackbar.showSnackbar(context, key, 'Numero de telefono invalido');
    }
  }
}
