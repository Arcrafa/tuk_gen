import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';
import 'package:tuk_gen/tokens/environment.dart' as env;
import 'package:tuk_gen/core/utils/my_progress_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tuk_gen/tuk_gen.dart';
import 'package:tuk_gen/design/pages/login/verification_code.dart';
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
  BuildContext _context;
  ProgressDialog _progressDialog;
  AuthProvider(BuildContext context) {
    _firebaseAuth = FirebaseAuth.instance;
    _clientProvider = new ClientProvider();
    _driverProvider = new DriverProvider();
    _context = context;
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
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

  Future<bool> checkIfUserIsAuth() async {
    print(await getAppName());

    bool isSigned = isSignedIn();
    if (isSigned) {
      if(env.appName=='tuky'){
        Client client =
        await _clientProvider.getById(getUser().uid);
        if (client != null) {
          print('El cliente no es nulo');
          return true;
        }else{
          return await registrar();
        }
      }else

      if(env.appName=='tuky driver'){
        Driver driver =
        await _driverProvider.getById(getUser().uid);
        if (driver != null) {
          print('El conductor no es nulo');
          return true;
        }else{
          return await registrar();
        }
      }

    } else {

      print('NO ESTA LOGEADO');

      return false;
    }
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

  Future<bool> signInWithGoogle() async {
    _progressDialog.show();
    String errorMessage;
    try {
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

      await _firebaseAuth.signInWithCredential(credential);
      // Once signed in, return the UserCredential
    } catch (error) {
      print(error);
      errorMessage = error.code;
    }
    _progressDialog.hide();
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    login();
    return true;
  }

  Future<bool> signInWithFacebook() async {
    _progressDialog.show();
    String errorMessage;
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
      errorMessage = 'error';
    }
    _progressDialog.hide();
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    login();
    return true;
  }

  Future<bool> signInWithPhone(String phone) async {
    _progressDialog.show();
    String errorMessage;
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+57 ' + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          print('llega aqui');
          // Sign the user in (or link) with the auto-generated credential
          await _firebaseAuth.signInWithCredential(credential);
          _progressDialog.hide();
        },
        verificationFailed: (FirebaseAuthException e) {
          print('print de eror');
          print(e.code);
          _progressDialog.hide();
        },
        codeSent: (String verificationId, [int forecResendingToken]) {
          _progressDialog.hide();
          sheetCode(_context,verificationId,this,_firebaseAuth);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('----------------time out------------');
        },
      );
    } catch (error) {
      print(error);
      errorMessage = error.code;
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return true;
  }

  void login() async {
    try {
      if (await checkIfUserIsAuth()) {
        // CREO QUE ESTO DEJA DE SER NECESARIO
        Client client = await _clientProvider.getById(getUser().uid);

        if (client != null) {
          Navigator.pushNamedAndRemoveUntil(_context, 'home', (route) => false);
        } else {
          //TODO: este debe enviar a la ventana de completar info
          Navigator.pushNamedAndRemoveUntil(_context, 'home', (route) => false);
        }
      } else {
        /*
          ENTRA AQUI CUANDO EL USARIO ES RECIEN CREADO PERO NO ENTIENDO POR QUE================================================
         */

        print("retorno false tras crear el cliente=================================================================================");
        Navigator.pushNamedAndRemoveUntil(_context, 'home', (route) => false);
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
