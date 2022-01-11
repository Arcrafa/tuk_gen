import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';
import 'package:tuk_gen/core/utils/snackbar.dart';
import 'package:tuk_gen/design/atoms/otp_widget.dart';
import 'package:tuk_gen/design/atoms/button_app.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';
import 'package:tuk_gen/tokens/environment.dart' as env;

class AuthProvider {
  ClientProvider _clientProvider;
  DriverProvider _driverProvider;
  FirebaseAuth _firebaseAuth;
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
    _clientProvider = new ClientProvider();
    _driverProvider = new DriverProvider();
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return false;
    }

    return true;
  }

  void checkIfUserIsLogged(BuildContext context, String typeUser) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      // QUE EL USUARIO ESTA LOGEADO
      if (user != null && typeUser != null) {
        if (typeUser == 'client') {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, 'driver/map', (route) => false);
        }
        print('El usuario esta logeado');
      } else {
        print('El usuario no esta logeado');
      }
    });
  }

  Future<bool> login(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      // CORREO INVALIDO
      // PASSWORD INCORRECTO
      // NO HAY CONEXION A INTERNET
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> createDriver() async {
    Driver driver = new Driver(
      id: this.getUser().uid,
      email: this.getUser().email,
    );
    print(driver);
    return null != await _driverProvider.create(driver);
  }

  Future<bool> driverExist() async {
    Driver driver = await _driverProvider.getById(this.getUser().uid);

    if (driver != null) {
      print('El driver no es nulo');
      return true;
    } else {
      return this.createDriver();
    }
  }

  Future<bool> createClient() async {
    Client client = new Client(
      id: this.getUser().uid,
      email: this.getUser().email,
    );
    print(client);
    return null != await _clientProvider.create(client);
  }

  Future<bool> clientExist() async {
    Client client = await _clientProvider.getById(this.getUser().uid);
    //print('CLIENT: $client');
    //_progressDialog.hide();
    if (client != null) {
      print('El cliente no es nulo');
      return true;
    } else {
      return this.createClient();
    }
  }

  Future<bool> registrar() async {
    if (env.appName == 'tuky') {
      return clientExist();
    } else if (env.appName == 'tuky_driver') {
      return driverExist();
    }
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    User user = (await _firebaseAuth.signInWithCredential(credential)).user;
    // Once signed in, return the UserCredential
    return user;
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
      // get the user data
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      final AuthCredential authCredential =
          FacebookAuthProvider.credential(accessToken.token);
      await _firebaseAuth.signInWithCredential(authCredential);
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    }
  }

  Future<bool> signInWithPhone(String phone, BuildContext context) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+57 ' + phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        print('llega aqui');
        // Sign the user in (or link) with the auto-generated credential
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('print de eror');
        print(e.code);
      },
      codeSent: (String verificationId, [int forecResendingToken]) {
        showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: OTPFields(
                        pin1: pin1Controller,
                        pin2: pin2Controller,
                        pin3: pin3Controller,
                        pin4: pin4Controller,
                        pin5: pin5Controller,
                        pin6: pin6Controller,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                      child: ButtonApp(
                        onPressed: () async {
                          String pin1 = pin1Controller.text.trim();
                          String pin2 = pin2Controller.text.trim();
                          String pin3 = pin3Controller.text.trim();
                          String pin4 = pin4Controller.text.trim();
                          String pin5 = pin5Controller.text.trim();
                          String pin6 = pin6Controller.text.trim();

                          String code = '$pin1$pin2$pin3$pin4$pin5$pin6';

                          final credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: code);
                          final userCredential = await _firebaseAuth
                              .signInWithCredential(credential);
                          final user = userCredential.user;
                          if (user != null) {
                            return user;
                          } else {
                            print('user is null');
                            Navigator.of(context).pop();
                          }
                        },
                        text: 'Registrar ahora',
                        colors: [SECUNDARIO, PRIMARIO, ACCENT2, ACCENT3],
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('time out------------');
      },
    );

    return null;
  }
}
