import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tuk_gen/core/providers/auth_provider.dart';

class LogoApp extends StatefulWidget {
  const LogoApp({Key key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  AuthProvider _authProvider;
  Future<bool> _isSigned;

  @override
  void initState() {
    super.initState();
    _authProvider = new AuthProvider(context);

    _isSigned = _authProvider.checkIfUserIsAuth();

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
                gaplessPlayback: true, fit: BoxFit.cover)));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
