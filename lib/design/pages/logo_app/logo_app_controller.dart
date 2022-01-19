import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:tuk_gen/core/providers/auth_provider.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';

//TODO: esta clase no esta haciendo nada quitar despues si todo sigue funcionando
class LogoAppController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();


  AuthProvider _authProvider;

  ClientProvider _clientProvider;

  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;

  Future init(BuildContext context) async {
    this.context = context;

    _authProvider = new AuthProvider(this.context);
    _clientProvider = new ClientProvider();
  }




}