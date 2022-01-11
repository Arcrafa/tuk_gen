import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';
import 'package:tuk_gen/core/providers/auth_provider.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';
import 'package:tuk_gen/core/utils/my_progress_dialog.dart';
import 'package:tuk_gen/core/utils/shared_pref.dart';
import 'package:tuk_gen/core/utils/snackbar.dart' as utils;
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  ClientProvider _clientProvider;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'client/register');
  }

  void goToConfirmEmailPage() {
    Navigator.pushNamed(context, 'ConfirmEmail');
  }

  void goToPasswordPage() {
    Navigator.pushNamed(context, 'restorePassword');
  }

  void goToVerificationEmailPage() {
    Navigator.pushNamed(context, 'VerificationmEmail');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    _progressDialog.show();

    try {
      bool isLogin = await _authProvider.login(email, password);

      if (isLogin) {
        print('El usuario esta logeado');

        Client client =
            await _clientProvider.getById(_authProvider.getUser().uid);
        print('CLIENT: $client');
        _progressDialog.hide();
        if (client != null) {
          print('El cliente no es nulo');
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        }
      } else {
        utils.Snackbar.showSnackbar(
            context, key, 'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }
    } catch (error) {
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }
  }

  void loginWithGoogle() async {
    User user = await _authProvider.signInWithGoogle();
    print(user);
  }

  void loginWithFacebook() async {
    await _authProvider.signInWithFacebook();
  }

  void loginWithPhone() async {
    //_progressDialog.show();
    String phone = phoneController.text.trim();
    print(phone);
    if (phone.length == 10) {
      await _authProvider.signInWithPhone(phone, context);
      //_progressDialog.hide();
    } else {
      //_progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Numero de telefono invalido');
    }
  }
}
