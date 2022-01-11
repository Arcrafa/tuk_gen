import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';
import 'package:tuk_gen/core/providers/auth_provider.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';

import 'package:tuk_gen/tokens/environment.dart' as env;
import 'package:tuk_gen/tuk_gen.dart';
class LogoApp extends StatefulWidget {
  const LogoApp({Key key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  AuthProvider _authProvider;

  ClientProvider _clientProvider;
  DriverProvider _driverProvider;

  Future<bool> _isSigned;
  ProgressDialog _progressDialog;



  @override
  void initState() {
    super.initState();
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _driverProvider = new DriverProvider();

    _isSigned = checkIfUserIsAuth();

    controller =
        AnimationController(duration: const Duration(seconds: 7), vsync: this);
    // #docregion addListener
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        // #enddocregion addListener
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
        // #docregion addListener
      });
    // #enddocregion addListener
    controller.forward().whenComplete(() async => {
          // put here the stuff you wanna do when animation completed!

          if (await _isSigned)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home', (Route<dynamic> route) => false)
            }
          else
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (Route<dynamic> route) => false)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/gif/splash.gif",
                gaplessPlayback: true, fit: BoxFit.fill)));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> checkIfUserIsAuth() async {
    print(await getAppName());
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {
      if(env.appName=='tuky'){
        Client client =
        await _clientProvider.getById(_authProvider.getUser().uid);
        if (client != null) {
          print('El cliente no es nulo');
          return true;
        }else{
          return await _authProvider.registrar();
        }
      }else

      if(env.appName=='tuky driver'){
        Driver driver =
        await _driverProvider.getById(_authProvider.getUser().uid);
        if (driver != null) {
          print('El conductor no es nulo');
          return true;
        }else{
          return await _authProvider.registrar();
        }
      }

    } else {

      print('NO ESTA LOGEADO');

      return false;
    }
  }
}
