import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sign_button/sign_button.dart';
import 'package:tuk_gen/design/pages/login/login_controller.dart';
import 'package:tuk_gen/design/atoms/button_app.dart';
import 'package:tuk_gen/fundation/color_fundation.dart';
import 'package:tuk_gen/design/organisms/custom_keyboard/custom_keyboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();
  String text = '';
  FocusNode _focus = FocusNode();
  OverlayState overlayState;
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
    _focus.addListener(_onFocusChange);
    overlayState = Overlay.of(context);
  }

  @override
  Widget build(BuildContext context) {
    print('METODO BUILD');

    return Scaffold(
      key: _con.key,
      //appBar: AppBar(automaticallyImplyLeading: false),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (overlayEntry != null) {
                overlayEntry.remove();
                overlayEntry = null;
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _bannerApp(),
                  _textDescription(),
                  _textLogin(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  _textFieldPhone(),
                  _buttonLogin(),
                  _socialButtons(),
                  _slogan(),
                ],
              ),
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

  Widget _socialButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          //TODO: acomodar  el torcido de los botones
          Row(children: <Widget>[
            Expanded(
                child: Divider(height: 30, endIndent: 20, color: Colors.black)),
            Text("O Con",
                style: TextStyle(fontSize: 18, color: Colors.grey[900])),
            Expanded(
                child: Divider(height: 30, indent: 20, color: Colors.black)),
          ]),
          Container(
            alignment: Alignment.center,
            child: Row(
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: ButtonApp(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (overlayEntry != null) {
            overlayEntry.remove();
            overlayEntry = null;
          }
          _con.loginWithPhone();
        },
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
          focusNode: _focus,
          showCursor: true,
          readOnly: true,
          controller: _con.phoneController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: '3112334455',
              labelText: 'Telefono',
              labelStyle: TextStyle(fontSize: 23),
              suffixIcon: Icon(
                Icons.phone,
                color: PRIMARIO,
              ))),
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

  void _insertText(String myText) {
    final text = _con.phoneController.text;
    final textSelection = _con.phoneController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _con.phoneController.text = newText;
    _con.phoneController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _con.phoneController.text;
    final textSelection = _con.phoneController.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _con.phoneController.text = newText;
      _con.phoneController.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _con.phoneController.text = newText;
    _con.phoneController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  void _showOverlay() async {
// Declaring and Initializing OverlayState
    // and OverlayEntry objects

    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.30,
          child: CustomKeyboard(
            onTextInput: (myText) {
              _insertText(myText);
            },
            onBackspace: () {
              _backspace();
            },
            onKeyboardHide: () {
              FocusScope.of(context).unfocus();
              if (overlayEntry != null) {
                overlayEntry.remove();
                overlayEntry = null;
              }
            },
          ),
        ),
      );
    });
    overlayState.insert(overlayEntry);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) _showOverlay();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }
}
