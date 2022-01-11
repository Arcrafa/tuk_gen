import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sign_button/sign_button.dart';
import 'package:tuk_gen/design/pages/login/login_controller.dart';
import 'package:tuk_gen/design/atoms/button_app.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();

  @override
  void initState() {
    super.initState();
    print('INIT STATE');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('METODO BUILD');

    return Scaffold(
      key: _con.key,
      //appBar: AppBar(automaticallyImplyLeading: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _bannerApp(),
                _textDescription(),
                _textLogin(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                _textFieldPhone(),
                _buttonLogin(),
                _socialButtons(),
                //_textFieldEmail(),
                //_textFieldPassword(),
                //
                //_textDontHaveAccount(),
                //_textNotpassword(),
                _slogan()
              ],
            ),
          ),
          new Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              //title: Text('Hello world'),
              backgroundColor: Colors.transparent, //No more green
              elevation: 0.0, //Shadow gone
            ),
          )
        ],
      ),
    );
  }

  Widget _socialButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          Row(children: <Widget>[
            Expanded(
                child: Divider(height: 30, endIndent: 20, color: Colors.black)),
            Text("O Con",
                style: TextStyle(fontSize: 18, color: Colors.grey[900])),
            Expanded(
                child: Divider(height: 30, indent: 20, color: Colors.black)),
          ]),
          Row(
            //TODO: conectar los logins
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: SignInButton(
                    buttonType: ButtonType.google,
                    width: 130,
                    btnText: 'Google',
                    onPressed: () {
                      _con.loginWithGoogle();
                    }),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: SignInButton(
                    buttonType: ButtonType.facebook,
                    width: 130,
                    btnText: 'Facebook',
                    onPressed: () {
                      _con.loginWithFacebook();
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _textNotpassword() {
    return GestureDetector(
      onTap: _con.goToConfirmEmailPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          '¿Olvidaste tu Contraseña?',
          style: TextStyle(fontSize: 18, color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          '¿No tienes cuenta?',
          style: TextStyle(fontSize: 18, color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ButtonApp(
        onPressed: _con.loginWithPhone,
        text: 'Iniciar sesion',
        color: PRIMARIO,
        textColor: Colors.white,
        colors: [SECUNDARIO, PRIMARIO, ACCENT2, ACCENT3],
      ),
    );
  }

  Widget _textFieldPhone() {
    //TODO conectar login telefonico
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: '3112334455',
            labelText: 'Telefono',
            labelStyle: TextStyle(fontSize: 23),
            suffixIcon: Icon(
              Icons.phone,
              color: PRIMARIO,
            )),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
            hintText: 'correo@gmail.com',
            labelText: 'Correo electronico',
            suffixIcon: Icon(
              Icons.email_outlined,
              color: PRIMARIO,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
            labelText: 'Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: PRIMARIO,
            )),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        'Continua con tu',
        style: TextStyle(
            color: Colors.black87, fontSize: 24, fontFamily: 'NimbusSans'),
      ),
    );
  }

  Widget _slogan() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/img/slogan.png',
        width: 250,
        height: 100,
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Inicio de sesion',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [SECUNDARIO, PRIMARIO, ACCENT2, ACCENT3])),
        //color: MyColors.primario,
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/img/tuky_logo.png',
                  width: 130,
                  height: 130,
                )),
            Container(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/img/nombre_colores.png',
                  width: 250,
                  height: 100,
                ))
          ],
        ),
      ),
    );
  }
}
