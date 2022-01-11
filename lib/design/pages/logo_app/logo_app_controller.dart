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
import 'package:tuk_gen/tokens/environment.dart' as env;
import 'package:package_info/package_info.dart';

class LogoAppController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();


  AuthProvider _authProvider;

  ClientProvider _clientProvider;

  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;

  Future init(BuildContext context) async {
    this.context = context;

    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
   // _progressDialog =MyProgressDialog.createProgressDialog(context, 'Espere un momento...');

    checkIfUserIsAuth();
  }

  Future<bool> checkIfUserIsAuth() async {
    bool isSigned = _authProvider.isSignedIn();

    if (isSigned) {
      Client client =
      await _clientProvider.getById(_authProvider.getUser().uid);
      if (client != null) {
        print('El cliente no es nulo');
        //Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        return true;
      }
    } else {
      print('======= consultando desde que app cargan tu_gen=======');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      print(packageInfo.appName);
      //print('NO ESTA LOGEADO');


      return false;
    }
  }



}